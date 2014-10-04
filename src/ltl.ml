(* LTL.ML

   Transforme un graphe RTL étiquetté par des pseudo registres
   en un même arbre décoré avec des registres physiques, après
   avoir effectué une allocation de registre -- module Reg_alloc
*)

open Reg_alloc
open Fgraph
open Utils
open Enums 

let graph = ref Label.M.empty

let generate ins =
  let fresh = Label.fresh () in
  graph := Label.M.add fresh ins !graph ;
  fresh

(* Registres temporaires utilisés pour le transfert de pseudo registres *)

let tmp1 = Reg.v1
let tmp2 = Reg.fp
let sp   = Reg.sp


let alloc_stack size nextl = 
  if size = 0 then nextl
  else generate **>
    Unop (sp, Maddi (iconst_of_int (-size)), sp, nextl)

let free_stack size nextl = alloc_stack (-size) nextl

let fp_to_sp fs = fs - word_size


let lookup col preg = 
  try Reg.M.find preg col 
  with Not_found -> assert false

let load_stack fs ret offset nextl =
  Load (ret, offset + (fp_to_sp fs), sp, nextl)

let store_stack fs arg offset nextl =
  Store (arg, offset + (fp_to_sp fs), sp, nextl)

let write col fs preg nextl = match lookup col preg with
  | Creg r -> r, nextl
  | Cspilled pos -> tmp1, 
    generate **> store_stack fs tmp1 pos nextl

let read1 col fs preg f = match lookup col preg with
  | Creg r -> f r
  | Cspilled pos -> load_stack fs tmp1 pos (generate **> f (tmp1))

let read2 col fs preg1 preg2 f = 
  match lookup col preg1, lookup col preg2 with
    | Creg r1, Creg r2 -> f r1 r2
    | Creg r1, Cspilled pos2 -> 
        load_stack fs tmp2 pos2 (generate **> f r1 tmp2)
    | Cspilled pos1, Creg r2 ->
        load_stack fs tmp1 pos1 (generate **> f tmp1 r2)
    | Cspilled pos1, Cspilled pos2 ->
        load_stack fs tmp1 pos1 (generate **> 
        load_stack fs tmp2 pos2 (generate **> f tmp1 tmp2))
  

let convert_instr col fs = function
  | Const (r, c, l) ->
      let r, l = write col fs r l in
      Const (r, c, l)

  | La (r, id, l) ->
      let r, l = write col fs r l in
      La (r, id, l)

  | Unop (r, op, a, l) ->
      read1 col fs a (fun a ->
        let r, l = write col fs r l in
        Unop (r, op, a, l))

  | Binop (r, op, a1, a2, l) ->
      read2 col fs a1 a2 (fun a1 a2 ->
        let r, l = write col fs r l in
        Binop (r, op, a1, a2, l))

  | Call (id, nargs, l) -> Call (id, nargs, l)

  | Callr (r, nargs, l) ->
      read1 col fs r (fun r ->
        Callr (r, nargs, l) )

  | Load (d, o, s, l) ->
      read1 col fs s (fun s ->
        let d, l = write col fs d l in
        Load (d, o, s, l))

  | Store (s, o, d, l) ->
      read2 col fs s d (fun s d ->
        Store (s, o, d, l))

  | Move (s, d, l) ->
      begin match lookup col s, lookup col d with
        | w1, w2 when w1 = w2 -> Goto l
        | Creg s, Creg d ->
            Move (s, d, l)
        | Creg s, Cspilled off_d -> 
            load_stack fs s off_d l
        | Cspilled off_s, Creg d ->
            store_stack fs d off_s l
        | Cspilled off_s, Cspilled off_d ->
            load_stack fs tmp1 off_d (generate **>
            store_stack fs tmp1 off_s l)
      end

  | Load_stack (r, o, l) ->
      let r, l = write col fs r l in
      load_stack fs r o l

  | Store_stack (r, o, l) ->
      read1 col fs r (fun r ->
        store_stack fs r o l)

  | Stack_addr (r, o, l) ->
      let r, l = write col fs r l in
      Unop (r, Maddi (iconst_of_int ((fp_to_sp fs) + o)), sp, l)

  | Ubranch (ub, r, tl, fl) ->
      read1 col fs r (fun r ->
        Ubranch (ub, r, tl, fl))

  | Bbranch (bb, r1, r2, tl, fl) ->
      read2 col fs r1 r2 (fun r1 r2 ->
        Bbranch (bb, r1, r2, tl, fl))

  | Goto l -> Goto l
  | Syscall l -> Syscall l

  | Alloc_frame  l -> Goto (alloc_stack fs l)
  | Delete_frame l -> Goto (free_stack fs l)

  | Return -> Return



let convert_proc spill_all proc = 

  graph := Label.M.empty ;

  let new_frame_size, col = 
    (if spill_all then Reg_alloc.spill_all else Reg_alloc.alloc) proc in

  let proc_graph = Label.M.map 
    (convert_instr col new_frame_size) proc.proc_graph in


  (* On fusionne avec les nouvelles instructions crées *)
  let proc_graph = Label.M.fold (Label.M.add) !graph proc_graph in

  let proc' = {proc with 
    proc_graph = proc_graph ; 
    proc_frame_size = new_frame_size} in

   proc'
