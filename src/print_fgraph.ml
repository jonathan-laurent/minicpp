(* PRINT_FGRAPH.ML
   Rendu du graphe de flot de controle
*)

open Format
open Fgraph
open Enums
open Liveness


let print_label ff l = fprintf ff "L%d" l

let print_iconst_base ff = function
  | Dec -> fprintf ff ""
  | Bin -> fprintf ff "b"
  | Hex -> fprintf ff "h"
  | Oct -> fprintf ff "o"

let print_iconst ff (s, b) = fprintf ff "%s%a" s print_iconst_base b

let print_munop ff = function
  | Maddi c -> fprintf ff "addi %a" print_iconst c
  | Mneg    -> fprintf ff "neg"
  | Mnot    -> fprintf ff "not"

let print_mbinop ff = function
  | Madd  -> fprintf ff "add"
  | Msub  -> fprintf ff "sub"
  | Mmul  -> fprintf ff "mul"
  | Mdiv  -> fprintf ff "div"
  | Mmod  -> fprintf ff "mod"
  | Meq   -> fprintf ff "eq"
  | Mneq  -> fprintf ff "neq"
  | Mlt   -> fprintf ff "lt"
  | Mleq  -> fprintf ff "leq"
  | Mgt   -> fprintf ff "gt"
  | Mgeq  -> fprintf ff "geq"

let print_ubranch ff = function
  | Beqz  -> fprintf ff "beqz"
  | Bneqz -> fprintf ff "bneqz"

let print_bbranch ff = function
  | Beq -> fprintf ff "beq"
  | Bneq -> fprintf ff "bneq"


let print_pseudo_reg ff = function
  | Reg.Pseudo i  -> fprintf ff "%%%d" i
  | Reg.Real id   -> fprintf ff "%s" (Reg.name_of_id id)

let print_real_reg ff id = fprintf ff "%s" (Reg.name_of_id id)

let print_instr print_reg ff = function
  | Const (r, c, l) -> 
      fprintf ff "%a <- %a --> %a" 
        print_reg r print_iconst c print_label l

  | Unop (r, op, arg, l) ->
      fprintf ff "%a <- %a %a --> %a" 
        print_reg r print_munop op print_reg arg print_label l

  | Binop (r, op, arg1, arg2, l) ->
      fprintf ff "%a <- %a %a, %a --> %a" 
        print_reg r print_mbinop op print_reg arg1 print_reg arg2 print_label l

  | Call (p, _, l) ->
      fprintf ff "call %s --> %a" 
        p print_label l

  | Callr (r, _, l) ->
      fprintf ff "callr %a --> %a" 
        print_reg r print_label l

  | Load (d, o, s, l) ->
      fprintf ff "%a <- lw (%d)%a --> %a" 
        print_reg d o print_reg s print_label l

  | Store (s, o, d, l) ->
      fprintf ff "sw %a, (%d)%a --> %a" 
        print_reg s o print_reg d print_label l

  | Move (d, s, l) ->
      fprintf ff "%a <- %a --> %a"
        print_reg d print_reg s print_label l

  | Load_stack (r, o, l) ->
      fprintf ff "%a <- stack(%d) --> %a"
        print_reg r o print_label l

  | Store_stack (r, o, l) ->
      fprintf ff "stack(%d) <- %a --> %a"
        o print_reg r print_label l

  | Stack_addr (r, o, l) ->
      fprintf ff "%a <- addr stack(%d) --> %a"
        print_reg r o print_label l

  | La (r, id, l) ->
      fprintf ff "%a <- la %s --> %a"
        print_reg r id print_label l

  | Ubranch (ub, r, l1, l2) ->
      fprintf ff "%a %a --> %a, %a"
        print_ubranch ub print_reg r print_label l1 print_label l2

  | Bbranch (bb, r1, r2, l1, l2) ->
      fprintf ff "%a %a, %a --> %a, %a"
        print_bbranch bb print_reg r1 print_reg r2 print_label l1 print_label l2

  | Goto l ->
      fprintf ff "goto %a" print_label l

  | Return -> 
      fprintf ff "return"

  | Syscall l ->
      fprintf ff "syscall --> %a" print_label l

  | Alloc_frame l ->
      fprintf ff "alloc-frame --> %a" print_label l

  | Delete_frame l ->
      fprintf ff "delete-frame --> %a" print_label l


let print_reg_set ff s = 
  List.iter (fun r -> fprintf ff "%a " print_pseudo_reg r) (Reg.S.elements s)

let print_liveness ff ii = 
  fprintf ff "IN = { %a}, OUT = { %a}" 
    print_reg_set ii.ii_live_in print_reg_set ii.ii_live_out


let print print_reg ff proc linfs_opt =
  fprintf ff "@[<v 0>%s : @," proc.Fgraph.proc_id ;
  fprintf ff "entry : %a@," print_label proc.proc_entry_label ;
  fprintf ff "exit : %a@,@[<v 0>"  print_label proc.proc_exit_label ;

  let bindings = Label.M.bindings proc.proc_graph in
  let bindings = List.sort (fun (l, _) (l', _) -> compare l' l) bindings in

  let print_instr ff (l, i) = fprintf ff "%a : %a" print_label l (print_instr print_reg) i in

  let print_instr_with_infos = match linfs_opt with 
    | None -> fun (l, i) -> fprintf ff "%a\n" print_instr (l, i)
    | Some infos -> fun (l, i) -> fprintf ff "@[<hv 4> %a \t\t  (%a)@]@," 
      print_instr (l, i) print_liveness (Label.M.find l infos)
      
  in    
  
  List.iter print_instr_with_infos bindings ; fprintf ff "@."
    


let print_ertl ff proc = print print_pseudo_reg ff proc None

let print_ertl_with_liveness_infos ff name proc (_, linfs) = 
  print print_pseudo_reg ff proc (Some linfs)

let print_ltl ff proc = print print_real_reg ff proc None
