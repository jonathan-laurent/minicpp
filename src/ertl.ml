(* ERTL.ML
   Génération du graphe de flot de controle 
   et explicitation des conventions d'appel
*)

open Utils
open Enums
open Fgraph
open Printf

let graph = ref Label.M.empty

let mk_generate_fun graph = fun ins ->
  let fresh = Label.fresh () in
  graph := Label.M.add fresh ins !graph ;
  fresh

let generate = mk_generate_fun graph
  
let loop f = 
  let goto_l = Label.fresh () in
  let entry_l = f goto_l in
  graph := Label.M.add goto_l (Goto entry_l) !graph ;
  entry_l


let bbranch_assoc = [(Meq, Beq) ; (Mneq, Bneq)]


(* Retourne une liste d'autant de registres frais 
   que [l] compte d'arguments *)
let assoc_fresh_regs l = List.map (fun _ -> Reg.fresh ()) l

let rec save_regs saved savers nextl = match saved, savers with
  | [], [] -> nextl
  | savee::nsaved, saver::nsavers -> generate **>
      Move (saver, savee, save_regs nsaved nsavers nextl)
  | _ -> assert false

let restore_regs saved savers nextl = save_regs savers saved nextl

let saving_regs saved f nextl = 
  let savers = assoc_fresh_regs saved in
  save_regs saved savers (f (restore_regs saved savers nextl))


let addi dest src c nextl = 
  if c = 0 then nextl else generate **>
  Unop (dest, Maddi (iconst_of_int c), src, nextl)

let storage_of_arg_id proc id = Smap.find id proc.proc_args
let storage_of_local  proc id = Smap.find id proc.proc_locals




(* La valeur de retour d'une expression n'est pas toujours
   sauvée dans un registre On fait donc souvent passer la valeur
   du registre de retour au sein d'une monade option. Ces deux
   fonctions utilitaires en facilitent l'utilisation.
*)

let retreg ret_opt nextl f = match ret_opt with
  | None -> nextl
  | Some ret -> f ret

let genret ret_opt nextl f = 
  retreg ret_opt nextl (fun ret -> generate **> f ret)






let load ret storage offset nextl = match storage with
  | Sreg reg -> generate **> Move (ret, reg, nextl)
  | Sstack pos -> generate **> 
      Load_stack (ret, pos + offset, nextl)


let store arg_reg dest_storage offset nextl = match dest_storage with
  | Sreg reg -> assert (offset = 0) ; generate **>
      Move (reg, arg_reg, nextl)

  | Sstack pos -> generate **> 
      Store_stack (arg_reg, offset + pos, nextl)


(* Lors de la passe précédente, toutes les valeurs locales dont l'adresse
   doit être calculée sont stockées sur la pile *)
let load_addr ret_opt storage offset nextl = match storage with
  | Sstack pos -> genret ret_opt nextl (fun ret -> 
      Stack_addr (ret, offset + pos, nextl))

  | _ -> assert false 



(* Place les premiers arguments situés dans [arg_regs] dans
   les registres [param_regs] et utilise les suivants dans la pile
   à partir de $sp + sp_offset *)
let rec set_args arg_regs param_regs sp_offset nextl = 
  match arg_regs, param_regs with
    | [], _ -> nextl
    | arg::nargs, reg::nregs -> generate **> 
        Move (reg, arg, set_args nargs nregs sp_offset nextl)

    | arg::nargs, [] -> generate **>
        Store (arg, sp_offset, Reg.Pseudo.sp, 
               set_args nargs [] (sp_offset - word_size) nextl)
        

let rec compute_exprs_list proc exprs regs nextl = match exprs, regs with
  | e::nes, reg::nregs -> 
      expr proc reg e (compute_exprs_list proc nes nregs nextl)

  | [], _ -> nextl
  | _ -> assert false


and load_lvalue proc ret lvalue  nextl = 
  load_lvalue_opt proc (Some ret) lvalue nextl

and load_lvalue_opt proc ret_opt (lvalue_addr, offset) nextl = 
match lvalue_addr with
  | Istree.Lv_global id ->
      let addr_reg = Reg.fresh () in genret ret_opt nextl (fun ret -> 
      La (addr_reg, id, (generate **>
      Load (ret, offset, addr_reg, nextl))))

  | Istree.Lv_arg id -> retreg ret_opt nextl (fun ret -> 
      load ret (storage_of_arg_id proc id) offset nextl )

  | Istree.Lv_local id -> retreg ret_opt nextl (fun ret -> 
      load ret (storage_of_local proc id) offset nextl)

  | Istree.Lv_ptr e ->
      let addr_reg = Reg.fresh () in
      expr proc addr_reg e (genret ret_opt nextl (fun ret -> 
      Load (ret, offset, addr_reg, nextl) ))


and store_lvalue proc arg_reg (lvalue_addr, offset) nextl = 
match lvalue_addr with
  | Istree.Lv_global id ->
      let global_addr = Reg.fresh () in generate **> 
      La (global_addr, id, (generate **>
      Store (arg_reg, offset, global_addr, nextl) ))

  | Istree.Lv_arg id -> 
      store arg_reg (storage_of_arg_id proc id) offset nextl

  | Istree.Lv_local id ->
      store arg_reg (storage_of_local proc id) offset nextl

  | Istree.Lv_ptr e ->
      let addr_reg = Reg.fresh () in
      expr proc addr_reg e (generate **> 
      Store (arg_reg, offset, addr_reg, nextl) )

and load_lvalue_address proc ret lvalue nextl = 
  load_lvalue_address_opt proc (Some ret) lvalue nextl


and load_lvalue_address_opt proc ret_opt (lvalue_base, offset) nextl = 
match lvalue_base with
  | Istree.Lv_global id -> 
      genret ret_opt nextl (fun ret -> 
        La (ret, id, (
        addi ret ret offset nextl )))

  | Istree.Lv_arg id -> 
      load_addr ret_opt (storage_of_arg_id proc id) offset nextl

  | Istree.Lv_local id -> 
      load_addr ret_opt (storage_of_local proc id) offset nextl

  | Istree.Lv_ptr e -> 
      expr_opt proc ret_opt e (retreg ret_opt nextl (fun ret -> 
      addi ret ret offset nextl ))


(* Incrémente une [lvalue] de [c].
   Retourne l'ancienne valeur de [lvalue] si [suf], la nouvelle sinon *)
and incr_of_const suf c proc ret_opt lvalue nextl = 
  let reg_b = Reg.fresh () in
  let reg_a = Reg.fresh () in

  load_lvalue proc reg_b lvalue (generate **>
  Unop (reg_a, (Maddi (iconst_of_int c)), reg_b, (
  store_lvalue proc reg_a lvalue (genret ret_opt nextl (fun ret ->
  Move (ret, (if suf then reg_b else reg_a), nextl))))))


and expr proc ret e nextl = expr_opt proc (Some ret) e nextl

and expr_void proc e nextl = expr_opt proc None e nextl

and expr_opt proc ret_opt e nextl = match e with
  | Istree.Seq (e1, e2) -> 
      expr_void proc e1 (
      expr_opt proc ret_opt e2 nextl )

  | Istree.Const c -> genret ret_opt nextl (fun ret ->
      Const (ret, c, nextl))


  | Istree.Unop (unop, e) ->

      let arg_reg = Reg.fresh () in 
      
      expr proc arg_reg e (genret ret_opt nextl (fun ret -> 
      Unop (ret, unop, arg_reg, nextl) ))

  | Istree.Lunop (Istree.Incr_suf, lvalue) ->
      incr_of_const true (1) proc ret_opt lvalue nextl

  | Istree.Lunop (Istree.Decr_suf, lvalue) ->
      incr_of_const true (-1) proc ret_opt lvalue nextl

  | Istree.Lunop (Istree.Incr_pre, lvalue) ->
      incr_of_const false (1) proc ret_opt lvalue nextl

  | Istree.Lunop (Istree.Decr_pre, lvalue) ->
      incr_of_const false (-1) proc ret_opt lvalue nextl  

  | Istree.Binop (binop, e1, e2) ->
      let arg1 = Reg.fresh () and arg2 = Reg.fresh () in
      expr proc arg1 e1 (
      expr proc arg2 e2 (genret ret_opt nextl (fun ret ->
      Binop (ret, binop, arg1, arg2, nextl) )))

  | Istree.Or (e1, e2) -> 
      cond proc e1 
      (genret ret_opt nextl (fun ret -> Const (ret, iconst_of_int 1, nextl)))
      (expr_opt proc ret_opt e2 nextl)

  | Istree.And (e1, e2) ->
      cond proc e1 
      (expr_opt proc ret_opt e2 nextl)
      (genret ret_opt nextl (fun ret -> Const (ret, iconst_of_int 0, nextl)))
      

  | Istree.Load lvalue -> load_lvalue_opt proc ret_opt lvalue nextl

  | Istree.Store (e, lvalue) -> 
      let arg = Reg.fresh () in
      expr proc arg e (
      store_lvalue proc arg lvalue (genret ret_opt nextl (fun ret ->
      Move (ret, arg, nextl))))

  | Istree.Load_address lvalue -> 
      load_lvalue_address_opt proc ret_opt lvalue nextl

  | Istree.Call (proc_id, args) ->
      let arg_regs = assoc_fresh_regs args in
      compute_exprs_list proc args arg_regs (
      call ret_opt proc_id arg_regs nextl )

  | Istree.New (obj_descr, ctor_id, args) -> genret ret_opt nextl (fun ret ->
     let arg_regs = assoc_fresh_regs args in

     (* Alloue de la mémoire *)
     Const (Reg.Pseudo.a0, 
           (iconst_of_int obj_descr.Istree.obj_size), generate **>
     Const (Reg.Pseudo.v0, (iconst_of_int 9), generate **>
     Syscall ( generate **>
     Move (ret, Reg.Pseudo.v0, 

     (* Dispose les pointeurs vers les vtables *)
     set_vt_ptrs proc obj_descr ret (

     (* Appelle la méthode du constructeur *)
     compute_exprs_list proc args arg_regs (
     call None ctor_id (ret::arg_regs) nextl
     )))))))

  | Istree.Set_vt (e, obj_descr) ->
      let addr_reg = Reg.fresh () in
      expr proc addr_reg e (
      set_vt_ptrs proc obj_descr addr_reg nextl )

  | Istree.Vcall (lhs, vt_ofs, in_vt_ofs, args) ->
      let lhs_reg = Reg.fresh () in
      let arg_regs = assoc_fresh_regs args in

      compute_exprs_list proc args arg_regs (
      expr proc lhs_reg lhs (
      vcall ret_opt lhs_reg vt_ofs in_vt_ofs arg_regs nextl ))


and call ret_opt proc_id arg_regs nextl = generate **> 

  Store (Reg.Pseudo.ra, - word_size, Reg.Pseudo.sp, (
  set_args arg_regs Reg.params (-2 * word_size) (generate **>
  Call (proc_id, List.length arg_regs, generate **>
  Load (Reg.Pseudo.ra, - word_size, Reg.Pseudo.sp, 
        (genret ret_opt nextl (fun ret ->
  Move (ret, Reg.Pseudo.v0, nextl))))))))


and vcall ret_opt lhs_reg vt_ofs in_vt_ofs arg_regs nextl = 

  let this_reg = Reg.fresh () 
  and vt_reg = Reg.fresh () 
  and tmp = Reg.fresh ()
  in generate **>

  Load (vt_reg, vt_ofs, lhs_reg, (generate **>

  (* [tmp] contient la valeur du delta *)
  Load (tmp, in_vt_ofs, vt_reg, (generate **>
  Binop (this_reg, Madd, tmp, lhs_reg, generate **> (

  (* [tmp] contient maintenant l'adresse de la fonction *)
  Load (tmp, in_vt_ofs + word_size, vt_reg, (generate **>

  Store (Reg.Pseudo.ra, - word_size, Reg.Pseudo.sp, (
  set_args (this_reg::arg_regs) Reg.params (-2 * word_size) (generate **>
  Callr (tmp, (List.length arg_regs + 1), generate **>
  Load (Reg.Pseudo.ra, - word_size, Reg.Pseudo.sp, 
        (genret ret_opt nextl (fun ret ->
  Move (ret, Reg.Pseudo.v0, nextl))))))))))))))))


and set_vt_ptrs proc obj_descr addr_reg nextl =

  let tmp = Reg.fresh () in
  
  List.fold_right (fun (offset, vt) acc -> generate **>
    La (tmp, vt.Istree.vtable_id, generate **>
    Store (tmp, offset, addr_reg, acc) ))

    obj_descr.Istree.obj_vtables
    nextl 
    



(* Evalue séquentiellement une liste d'expressions en jetant tous
   les résultats obtenus
*)
and exprs_void proc es nextl = match es with
  | [] -> nextl
  | e::nes -> expr_void proc e (exprs_void proc nes nextl)

      
and instr proc ins nextl = match ins with
  | Istree.Nop -> nextl

  | Istree.Expr e -> expr_void proc e nextl

  | Istree.Return None -> generate **> 
      Goto (proc.proc_exit_label)

  | Istree.Return (Some e) -> 
      expr proc Reg.result e ( generate **>
      Goto (proc.proc_exit_label))

  | Istree.Print_int e -> saving_regs []
      (fun nextl ->
        expr proc Reg.Pseudo.a0 e (generate **>
        Const (Reg.Pseudo.v0, (iconst_of_int 1), generate **>
        Syscall nextl))) nextl

  | Istree.Print_string id -> saving_regs [] 
      (fun nextl -> generate **>
        La (Reg.Pseudo.a0, id, generate **>
        Const (Reg.Pseudo.v0, (iconst_of_int 4), generate **>
        Syscall nextl ))) nextl

  | Istree.Cond (e, then_is, else_is) -> 
      cond proc e (instrs proc then_is nextl) (instrs proc else_is nextl)   

  | Istree.While (e, is) -> 
      loop (fun goto_l -> cond proc e (instrs proc is goto_l) nextl)

  | Istree.For (ies, ce, nes, is) ->

      exprs_void proc ies (
      loop (fun goto_l ->

        cond proc ce 
          
          (* Si la condition est vérifiée, on repart pour un tour *)
          (instrs proc is (
           exprs_void proc nes goto_l))

          (* Sinon on quitte la boucle *)
          (nextl)
        ))

     
and instrs proc ins nextl = match ins with
  | [] -> nextl
  | ins::next -> instr proc ins (instrs proc next nextl)



and cond proc e true_l false_l = match e with

  (* Le comportement de && et || est paresseux *)
  | Istree.And (e1, e2) ->
      cond proc e1
        
        (* Si [e1] est vrai, on regarde [e2] *)
        (cond proc e2 true_l false_l)
        
        (* Sinon, la condition n'est pas remplie *)
        false_l

  | Istree.Or (e1, e2) ->
      cond proc e1 true_l (cond proc e2 true_l false_l)

  | Istree.Binop (op, e1, e2) when List.mem op (List.map fst bbranch_assoc) ->
      
      let lhs = Reg.fresh () in
      let rhs = Reg.fresh () in
      
      expr proc lhs e1 (
      expr proc rhs e2 (generate **>
      Bbranch (List.assoc op bbranch_assoc, lhs, rhs, true_l, false_l)))

  | _ -> 
      let tmp = Reg.fresh () in
      expr proc tmp e (generate **>
      Ubranch (Bneqz, tmp, true_l, false_l))

      

(* Détermine la localisation des variables locales à partir de stack(fp_offset),
   ainsi que le prochain emplacement libre dans le cadre de pile *)
let rec choose_locals_storage locals fp_offset acc = match locals with
  | [] -> (acc, fp_offset)
  | (id, Istree.Sreg)::nlocals -> 
      choose_locals_storage nlocals fp_offset 
        (Smap.add id (Sreg (Reg.fresh ())) acc)

  | (id, Istree.Sstack size)::nlocals ->
      choose_locals_storage nlocals (fp_offset - size) 
        (Smap.add id (Sstack (fp_offset - size + word_size)) acc)

(* Détermine l'emplacement des arguments à partir du cinquième, 
   placé en stack(fp_offset)  *)
let rec add_extra_args_storage args fp_offset acc = match args with
  | [] -> acc
  | (id, _)::nargs -> 
      Smap.add id (Sstack fp_offset) 
        (add_extra_args_storage nargs (fp_offset - word_size) acc)


let rec move_arguments proc args param_regs nextl = match args, param_regs with
  | [], _ -> nextl
  | (arg_id, _)::nargs, param_reg::nparams ->
      store param_reg (storage_of_arg_id proc arg_id) 0 (
      move_arguments proc nargs nparams nextl)
  | _ -> assert false



let proc isproc = 
  
  graph := Label.M.empty;
  Reg.reset_fresh_counter ();

  let callee_saved = Reg.callee_saved in
  let savers = assoc_fresh_regs callee_saved in


  (* On trouve des emplacements pour les arguments passés par la pile *)

  let args_stack_size = word_size * 
    (max 0 (List.length isproc.Istree.proc_args - List.length Reg.params)) in

   let args_storage = add_extra_args_storage 
    (remove_prefix 4 isproc.Istree.proc_args) (-word_size) Smap.empty in

  (* On trouve des emplacements pour déplacer 
     les quatre premiers arguments *)

  let args_storage, next_frame_pos = choose_locals_storage
    (prefix 4 isproc.Istree.proc_args) 
    (- word_size - args_stack_size) args_storage in

  let locals_storage, next_frame_pos  = choose_locals_storage
    isproc.Istree.proc_locals next_frame_pos Smap.empty in 

  let exit_label =
    restore_regs callee_saved savers (generate **>
    Delete_frame (generate **> 
    Return )) in

  let proc = {
    proc_id                 =  isproc.Istree.proc_id ;
    proc_exit_label         =  exit_label ;
    proc_args               =  args_storage ;
    proc_locals             =  locals_storage ;
    proc_args_stack_size    =  args_stack_size ;
    proc_frame_size         =  - next_frame_pos ;

    proc_graph              =  Label.M.empty ;
    proc_entry_label        =  Label.dummy
  } in
                               

  let entry_label = generate **>
    Alloc_frame (
    save_regs callee_saved savers **>
    move_arguments proc (prefix 4 isproc.Istree.proc_args) Reg.params (
    instrs proc isproc.Istree.proc_body exit_label )) in 

  { proc with proc_graph = !graph ; proc_entry_label = entry_label }



let convert_procs isprocs = List.map proc isprocs

open Format
open Reg_alloc

let test isprog = 

  let rtlprocs = List.map proc isprog.Istree.prog_procs in

  List.iter (fun rtlproc -> 

    let liveness_infos = 
      Liveness.analyse rtlproc.proc_graph in

    let ff = formatter_of_out_channel stdout in

    Print_fgraph.print_ertl_with_liveness_infos 
      ff rtlproc.proc_id rtlproc liveness_infos )
    
    rtlprocs
