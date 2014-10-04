(* LINEARIZE.ML
   Production de code MIPS
*)

open Mips
open Printf
open Utils


(* Cette référence contient, à l'envers, le texte assembleur 
   crée jusqu'au point d'execution courant *)
let mips_instrs = ref []
let emit label mips = mips_instrs := (label, mips) :: !mips_instrs

(* Etiquettes déjà visitées au cours du parcours *)
let visited = Hashtbl.create 17

(* Etiquettes à conserver dans le code assembleur *)
let labels  = Hashtbl.create 17
let need_label l = Hashtbl.add labels l ()


let string_of_label l = sprintf "L%d" l

let string_of_iconst (s, b) = match b with
  | Enums.Dec -> sprintf "%s" s
  | Enums.Hex -> sprintf "0x%s" s
  | Enums.Oct -> sprintf "0%s" s
  | Enums.Bin -> sprintf "%sb" s

let regname = Reg.name_of_id

let inv_ubranch = function
  | Fgraph.Beqz -> Fgraph.Bneqz
  | Fgraph.Bneqz -> Fgraph.Beqz

let inv_bbranch = function
  | Fgraph.Beq -> Fgraph.Bneq
  | Fgraph.Bneq -> Fgraph.Beq

let ubranch ub r lt = match ub with
  | Fgraph.Beqz -> Beqz (regname r, string_of_label lt)
  | Fgraph.Bneqz -> Bnez (regname r, string_of_label lt)

let bbranch bb r1 r2 lt = match bb with
  | Fgraph.Beq  -> Beq (regname r1, regname r2, string_of_label lt)
  | Fgraph.Bneq -> Bne (regname r1, regname r2, string_of_label lt)




let rec lin g l =
  if not (Hashtbl.mem visited l) then begin
    Hashtbl.add visited l ();
    try instr g l (Label.M.find l g)  
    with Not_found -> printf "{%s}" (string_of_label l)
  end else begin
    need_label l;
    emit (Label.fresh ()) (B (string_of_label l))
  end

and instr g l = function
  | Fgraph.Const (r, c, nl) ->
      emit l (Li (regname r, string_of_iconst c) ) ; 
      lin g nl

  | Fgraph.La (r, s, nl) ->
      emit l (La (regname r, s)) ;
      lin g nl

  | Fgraph.Unop (r, Enums.Maddi c, a, nl) ->
      emit l (Addi (regname r, regname a, string_of_iconst c)) ;
      lin g nl

  | Fgraph.Unop (r, Enums.Mneg, a, nl) ->
      emit l (Neg (regname r, regname a)) ;
      lin g nl
        
  | Fgraph.Unop (r, Enums.Mnot, a, nl) ->
      emit l (Set (Eq, regname r, regname a, Oreg "$0"));
      lin g nl

  | Fgraph.Binop (r, op, a1, a2, nl) ->

      let arith_assoc = 
        [(Enums.Madd, Mips.Add) ; (Enums.Msub, Mips.Sub) ; 
         (Enums.Mmul, Mips.Mul) ; (Enums.Mdiv, Mips.Div) ; 
         (Enums.Mmod, Mips.Rem)] in

      let cond_assoc = 
        [(Enums.Meq, Mips.Eq) ; (Enums.Mneq, Mips.Ne) ; 
         (Enums.Mlt, Mips.Lt) ; (Enums.Mleq, Mips.Le) ; 
         (Enums.Mgt, Mips.Gt) ; (Enums.Mgeq, Mips.Ge)] in
      
      begin try
              emit l (Arith (
                List.assoc op arith_assoc, 
                regname r, regname a1, Oreg (regname a2)))
        with Not_found ->
          begin 
              emit l (Set (
                List.assoc op cond_assoc, 
                regname r, regname a1, Oreg (regname a2)))
          end
      end ; lin g nl


  | Fgraph.Call (id, _, nl) ->
      emit l (Jal id) ; lin g nl

  | Fgraph.Callr (r, _, nl) ->
      emit l (Jalr (regname r)) ; lin g nl

  | Fgraph.Load (d, o, s, nl) ->
      emit l (Lw (regname d, Areg (o, regname s))) ; lin g nl

  | Fgraph.Store (s, o, d, nl) ->
      emit l (Sw (regname s, Areg (o, regname d))) ; lin g nl

  | Fgraph.Move (d, s, nl) ->
      emit l (Move (regname d, regname s)) ; lin g nl

  | Fgraph.Syscall nl ->
      emit l Syscall ; lin g nl

  | Fgraph.Return ->
      emit l (Jr "$ra")



  | Fgraph.Ubranch (ub, r, lt, lf) when not (Hashtbl.mem visited lf) ->
      need_label lt;
      emit l (ubranch ub r lt);
      lin g lf; 
      lin g lt

  | Fgraph.Ubranch (ub, r, lt, lf) when not (Hashtbl.mem visited lt) ->
      instr g l (Fgraph.Ubranch (inv_ubranch ub, r, lf, lt))

  | Fgraph.Ubranch (ub, r, lt, lf)  ->
      need_label lt; 
      need_label lf;
      emit l (ubranch ub r lt);
      emit l (B (string_of_label lf))


  | Fgraph.Bbranch (bb, r1, r2, lt, lf) when not (Hashtbl.mem visited lf) ->
      need_label lt ;
      emit l (bbranch bb r1 r2 lt);
      lin g lf; 
      lin g lt

  |  Fgraph.Bbranch (bb, r1, r2, lt, lf) when not (Hashtbl.mem visited lt) ->
      instr g l (Fgraph.Bbranch (inv_bbranch bb, r1, r2, lf, lt))

  | Fgraph.Bbranch (bb, r1, r2, lt, lf)  ->
      need_label lt; 
      need_label lf;
      emit l (bbranch bb r1 r2 lt);
      emit l (B (string_of_label lf))

  | Fgraph.Goto nl ->
      if Hashtbl.mem visited nl then begin
        need_label nl ;
        emit l (B (string_of_label nl))
      end else begin
        emit l Nop ;
        lin g nl
      end

  | _ -> assert false (* Les autres instructions auraient dû disparaitre *)
      







let linearize_proc proc = 

  mips_instrs := [] ;
  Hashtbl.clear visited ;
  Hashtbl.clear labels ;

  lin (proc.Fgraph.proc_graph) (proc.Fgraph.proc_entry_label) ;

  let text = List.fold_right (fun (l, mips_ins) acc ->

    let label = 
      if Hashtbl.mem labels l then 
        mips **> [Label (string_of_label l)]
      else nop 
    in
    let instr = 
      if mips_ins = Nop then nop else (mips [mips_ins]) 
    in
    acc ++ label ++ instr

  ) !mips_instrs Mips.nop
  in

  mips [Label proc.Fgraph.proc_id] ++ text



let prolog entry_point = 
  mips [Jal entry_point ; Li ("$v0", "10") ; Syscall]




let write_vtables obj = 

  let write_vtable (vt_offset, vt) =
    let mips = List.fold_right (fun (c, p) acc ->
      let delta = 
        try (Smap.find c obj.Istree.obj_supers_offsets) - vt_offset 
        with Not_found -> assert false in
      (Word [Wint (string_of_int delta)]) :: (Word [Waddr p]) :: acc)
      vt.Istree.vtable_contents []
    in Dlabel (vt.Istree.vtable_id) :: mips
  in
  
  List.fold_right (fun v acc -> (write_vtable) v @ acc)
    obj.Istree.obj_vtables []



let write_data_seg data =

  (* Prise en compte des constantes chaînes *)
  let mips = List.fold_right (fun (label, string) acc -> 
    (Asciiz (label, string)) :: acc ) data.Istree.data_string_consts [] in

  (* Allocation des variables globales *)
  let mips = List.fold_right (fun (label, size) acc ->
    (Space (label, size)) :: acc ) data.Istree.data_globals mips in

  (* Ecriture des vtables *)
  let mips = Smap.fold (fun _ descr acc -> acc @ (write_vtables descr)) 
    data.Istree.data_obj_descrs mips

  in mips



let prog data procs = 
  
  let text = 
    List.fold_left ( ++ ) (prolog data.Istree.data_entry_point) procs in

  let prog = 
    { text = text ;
      data = write_data_seg data }
  in prog
