(* IS.ML 
   Simplification de la couche objet et sélection d'instructions 
*)

open Istree
open Utils
open Printf
open Enums


(* Gestion des identifiants uniques *)

let dummy_id = ""
let dummy_label = "__dummy__"

type id_manager = {

  id_of_method     :  id Ttree.Methmap.t ;
  id_of_proc       :  id Ttree.Procmap.t ;
  id_of_global_var :  id Smap.t ;
}


let empty_id_manager = {

  id_of_method      =  Ttree.Methmap.empty ;
  id_of_global_var  =  Smap.empty ;
  id_of_proc        =  Ttree.Procmap.empty ;
}

let idmngr = ref empty_id_manager

let next_proc_id = ref 0
let next_method_id = ref 0
let next_global_var_id = ref 0

let next_string_id = ref 0
let string_consts = ref Idmap.empty

(* Renvoie l'identifiant unique d'une méthode. Le crée à la volée si besoin. *)

let id_of_method ((meth_name, profile) as method_id) =
  try Ttree.Methmap.find method_id !idmngr.id_of_method
  with Not_found ->
    begin
      let class_name = Typer.class_name_of_profile profile in
      let fresh = !next_method_id in
      let unique_id = sprintf "_m%d__%s__%s" fresh class_name meth_name in
      incr next_method_id ;
      idmngr := { !idmngr with 
        id_of_method = Ttree.Methmap.add method_id unique_id !idmngr.id_of_method } ;
      unique_id
    end


let id_of_global_var name = 
  try Smap.find name !idmngr.id_of_global_var
  with Not_found ->
    begin
      let fresh = !next_global_var_id in
      let unique_id = sprintf "_g%d__%s" fresh name in
      incr next_global_var_id ;
      idmngr := { !idmngr with 
        id_of_global_var = Smap.add name unique_id !idmngr.id_of_global_var } ;
      unique_id
    end

let id_of_proc ((proc_name, profile) as proc_id) = 
  try Ttree.Procmap.find proc_id !idmngr.id_of_proc
  with Not_found ->
    begin
      let fresh = !next_proc_id in
      let unique_id = sprintf "_p%d__%s" fresh proc_name in
      incr next_proc_id ;
      idmngr := { !idmngr with 
        id_of_proc = Ttree.Procmap.add proc_id unique_id !idmngr.id_of_proc} ;
      unique_id
    end


(* Identifiant de la vtable de [c1] associée au parent [c2] *)
let vtable_id c1 c2 = sprintf "_vt__%s__%s" c1 c2

let id_of_string str = 
  let fresh = !next_string_id in
  let id = sprintf "_s__%d" fresh in

  string_consts := Idmap.add id str !string_consts ;
  incr next_string_id; 
  id

   





(* Géneration des descripteurs d'objets et des vtables  *)


let empty_vtable = {
  vtable_id = "" ;
  vtable_class = "";
  vtable_size = 0 ;
  vtable_contents = []
}

let vt_entry_size = 2 * word_size


let add_vtable_entry impl v = 
  let cl = Typer.class_of_method impl in
  { v with
    vtable_size = v.vtable_size + vt_entry_size ;
    vtable_contents = v.vtable_contents @ [(cl, id_of_method impl)] 
  }


let rec gen_vtable prog overridings owner c =

  let cspec = Typer.resolve_class prog c in

  let old_table = 
    match cspec.Ttree.class_supers with
      | [] -> empty_vtable
      | leftmost_super :: _ -> gen_vtable prog overridings owner leftmost_super in

  let vt =

    List.fold_left
      (fun vtable virt_id ->

        try
          
          let _, _, impl = Ttree.Vsmap.find virt_id overridings in 
          add_vtable_entry impl vtable

        (* Si le typage est correct, alors on est forcemment dans
           une situation où A hérite de B et C qui définissent
           toutes les deux une fonction virtuelle h, redéfinie en C.
           Le représentant est celui de A *)
        with Not_found -> vtable)


      old_table cspec.Ttree.class_new_virts

  in {vt with vtable_id = vtable_id owner c ; vtable_class = c}

  

(* Calcule [obj_virts_offsets] *)

let virts_offsets cspec primary_vtable =

  let n_new_virts = List.length **> cspec.Ttree.class_new_virts in
  let _, virts_offsets =
  List.fold_left (fun (cur_off, vo) virt_id ->

      let repr, _, _ = 
        try Ttree.Vsmap.find virt_id cspec.Ttree.class_overridings 
        with Not_found -> assert false in
      
      (cur_off + vt_entry_size, Idmap.add (id_of_method repr) cur_off vo)
    )
    (primary_vtable.vtable_size - n_new_virts * vt_entry_size, Idmap.empty) 
    cspec.Ttree.class_new_virts
  in virts_offsets


(* Actualise le triplet (supers_offsets, obj_size, vtables) 
   en prenant en compte une classe parent supplémentaire *)

let add_super prog descrs c cspec = fun (so, cur_off, vts) super ->

  let overridings = cspec.Ttree.class_overridings in


  let super_descr = Smap.find super descrs in
  let super_supers_offsets = Smap.map (fun o -> o + cur_off) super_descr.obj_supers_offsets in

        (* Toutes les tables non primaires de l'objet parent sont reprises *)
  
  let vts = List.fold_left (fun svts (o, vt) ->
    let offset = cur_off + o in
    if offset = 0 then svts else
      svts @ [(offset, gen_vtable prog overridings c (vt.vtable_class) )]
  ) vts super_descr.obj_vtables in
  
  ( Smap.union so (Smap.add super cur_off super_supers_offsets), 
    cur_off + super_descr.obj_size,
    vts )
          
      

let var_size descrs var = 
  if var.Ttree.var_by_ref then word_size
  else match var.Ttree.var_ty with
    | Ttree.Tclass class_name -> (Smap.find class_name descrs).obj_size
    | _ -> word_size


(* Renvoie l'emplacement des champs propres et la taille totale de l'objet étant donné la position du
   premier d'entre eux
*)
let choose_fields_location descrs cspec first_field = 
  Smap.fold ( fun attr_name var (fields, cur_off) -> 
    (Smap.add attr_name cur_off fields, cur_off + var_size descrs var ) )
    cspec.Ttree.class_attributes (Smap.empty, first_field)


let gen_objects_descriptors prog = 

  let add_class c descrs = 

    let cspec = Smap.find c prog.Ttree.prog_classes in
    let supers = cspec.Ttree.class_supers in
    let overridings = cspec.Ttree.class_overridings in

    (* On génère la première vtable et on détermine la valeur de [vtable_virts_offsets] pour cet objet *)

    let primary_vtable = gen_vtable prog overridings c c in
    let virts_offsets = virts_offsets cspec primary_vtable in
    
    let supers_offsets, first_field, vtables = 
      List.fold_left (add_super prog descrs c cspec)
        (Smap.singleton c 0, 0, [(0, primary_vtable)]) supers in

    (* S'il n'y a plus d'ancêtres dans la hiérarchie, on alloue de l'espace pour une vtable *)
    let first_field = if supers = [] then first_field + word_size else first_field in

      (* On détermine enfin la position des champs *)

    let fields, obj_size = choose_fields_location descrs cspec first_field in

    let new_descr = {
      obj_supers_offsets = supers_offsets ;
      obj_first_field = first_field ;
      obj_size = obj_size ;
      obj_fields = fields ; 

      obj_vtables = vtables ;
      obj_virts_offsets = virts_offsets ;

    } in

    Smap.add c new_descr descrs
      
  in

  List.fold_right add_class prog.Ttree.prog_classes_order Smap.empty



(* Fonctions d'affichage *)

open Format

let print_vtable ff vtable = 
  List.iter (fun (class_id, proc_id) -> 
    fprintf ff "%s\n" proc_id )
    vtable.vtable_contents


let print_descriptor ff descrs obj =
  let lines = Array.make obj.obj_size "" in
  
  let print_sub offset sub = 
    Smap.iter (fun field_name f_off -> 
      lines.(offset + f_off) <- field_name) sub.obj_fields
  in
  begin
  
    print_sub 0 obj;

  
    List.iter (fun (t_off, table) -> 
      lines.(t_off) <- sprintf "VTABLE <%s>" table.vtable_id ) obj.obj_vtables ;

    Smap.iter (fun super offset ->
      print_sub offset (Smap.find super descrs) ) obj.obj_supers_offsets ;

    for i = 0 to obj.obj_size - 1 do
    if (i mod 4) = 0 then fprintf ff "%d. %s\n" i lines.(i)
    done ;
    
    (* On affiche les vtables *)

    print_newline ();
    
    List.iter (fun (offset, vtable) -> 
    fprintf ff "Details for vtable at offset %d : \n" offset ;
    print_vtable ff vtable ) obj.obj_vtables
  
  end
  

let print_objects_descriptors ff descrs = 
  Smap.iter (fun name descr ->
    fprintf ff "OBJECT <%s> \n" name ; 
    print_descriptor ff descrs descr ;
    fprintf ff "\n\n\n"
  ) descrs






(* Sélection d'instructions *)


(* Certains arguments ou certaines variables locales, dont l'adresse
   est demandée explicitement au cours du programme, doivent
   être stockés sur la pile quoi qu'il arrive.

   Lorsqu'une telle opération est détecrée dans [convert_expr],
   la variable affectée est mémorisée dans une de ces références.
*)

let stacked_args    = ref []
let stacked_locals  = ref []

let new_stacked_arg a = stacked_args := a::!stacked_args
let new_stacked_local l = stacked_locals := l::!stacked_locals

let reset_stacked_vars () = stacked_args := [] ; stacked_locals := []

let ensures_in_stack lvalue = match fst lvalue with
  | Lv_arg id -> new_stacked_arg id ; lvalue
  | Lv_local id -> new_stacked_local id ; lvalue
  | _ -> lvalue

let add_offset offset (lvalue_addr, old_offset) = 
  (lvalue_addr, old_offset + offset)

let mk_lvalue addr = (addr, 0)

let obj_class e = match e.Ttree.expr_ty with
  | Ttree.Tclass c -> c
  | Ttree.Tptr (Ttree.Tclass c) -> c
  | _ -> assert false



let field_offset descrs obj_class (attr_class, attr_name) = 
  let ofs1 = Smap.find attr_class
    (Smap.find obj_class descrs).obj_supers_offsets in
  let ofs2 = Smap.find attr_name (Smap.find attr_class descrs).obj_fields in
  ofs1 + ofs2


(* Récupère une valeur gauche à partir d'une expression *)
let rec convert_lvalue descrs expr = match expr.Ttree.expr_value with

  | Ttree.Argument id   -> mk_lvalue **> Lv_arg id
  | Ttree.Local_var id  -> mk_lvalue **> Lv_local id
  | Ttree.Global_var id -> mk_lvalue **> Lv_global (id_of_global_var id)

  | Ttree.Attribute (lhs, attr_id) ->
      add_offset (field_offset descrs (obj_class lhs) attr_id) (convert_lvalue descrs lhs)

  | Ttree.Unary_op (Unref, e) | Ttree.Implicit_op (Ttree.Ref_unref, e) ->
      mk_lvalue **> Lv_ptr (convert_expr descrs e)

  | _ -> mk_lvalue **> Lv_ptr (convert_expr descrs expr)


and load_address descrs e = 
  Load_address (ensures_in_stack (convert_lvalue descrs e))


(* Convertit une expression vue comme une rvalue *)
and convert_expr descrs expr = match expr.Ttree.expr_value with

  | Ttree.Implicit_op (Ttree.Cast (fromc, toc), e) -> 

      let e = convert_expr descrs e in
      let ofs = Smap.find toc (Smap.find fromc descrs).obj_supers_offsets in
      if ofs = 0 then e else
        Unop (Maddi (iconst_of_int ofs), e)
    
  | Ttree.Binary_op (Assign, lhs, rhs) ->
      Store (convert_expr descrs rhs, convert_lvalue descrs lhs) 

  | Ttree.Unary_op (Addr, e) | Ttree.Implicit_op (Ttree.Ref_addr, e) -> 
      load_address descrs e

  | Ttree.Unary_op (Unref, e) | Ttree.Implicit_op (Ttree.Ref_unref, e) -> 
      Load (mk_lvalue **> Lv_ptr (convert_expr descrs e))

  | Ttree.Unary_op (Not, e) -> Unop (Mnot, convert_expr descrs e)

  | Ttree.Unary_op (Unary_minus, e) -> Unop (Mneg, convert_expr descrs e)

  | Ttree.Unary_op (op, e) -> (* opérateurs ++ et -- *)
      
      let op_translation = 
        [(Incr_suf, Istree.Incr_suf) ; (Decr_suf, Istree.Decr_suf) ;
         (Incr_pre, Istree.Incr_pre) ; (Decr_pre, Istree.Decr_pre)] in

      Lunop (List.assoc op op_translation,  convert_lvalue descrs e)

  (* Accès en lecture à une valeur gauche *)
  | Ttree.Argument _ | Ttree.Local_var _ | Ttree.Global_var _ | Ttree.Attribute _  -> 
      Load (convert_lvalue descrs expr)        

  | Ttree.New (ctor_id, args) -> 
      let obj_descr = Smap.find (obj_class expr) descrs in
      New (obj_descr, id_of_method ctor_id, List.map (convert_expr descrs) args)

  | Ttree.Call (tproc_id, args) ->
      Call (id_of_proc tproc_id, List.map (convert_expr descrs) args)

  | Ttree.Call_meth (e, meth_id, args) ->
      let args = (load_address descrs e) :: (List.map (convert_expr descrs) args) in
      Call (id_of_method meth_id, args)

  | Ttree.Call_virt (e, meth_id, args) ->

      let meth_class = Typer.class_of_method meth_id in
      let obj_class = obj_class e in
      let meth_id' = id_of_method meth_id in

      let vt_offset = Smap.find meth_class
        (Smap.find obj_class descrs).obj_supers_offsets in

      let in_vt_offset = Smap.find meth_id'
        (Smap.find meth_class descrs).obj_virts_offsets in

      Vcall (load_address descrs e, vt_offset, in_vt_offset, List.map (convert_expr descrs) args)    
        
  | Ttree.Const True      -> Const ("1", Dec)
  | Ttree.Const False     -> Const ("0", Dec)
  | Ttree.Const Null      -> Const ("0", Dec)
  | Ttree.Const (Int c)   -> Const c


  (* Pour l'instant, aucune optimisation n'est faire sur la sélection d'instructions *)
  | Ttree.Binary_op (op, lhs, rhs) -> 

      let op_translation = 
        [(Eq, Meq) ; (Neq, Mneq) ; (Lt, Mlt) ; (Leq, Mleq) ;
         (Gt, Mgt) ; (Geq, Mgeq) ; (Plus, Madd); (Minus, Msub) ;
         (Mul, Mmul) ; (Div, Mdiv) ; (Mod, Mmod)] 
      in
      let lhs', rhs' = convert_expr descrs lhs, convert_expr descrs rhs in
      begin
        
        match op with
          | And -> Istree.And (lhs', rhs') 
          | Or -> Istree.Or (lhs', rhs')
          | _ -> 
              try Binop (List.assoc op op_translation, lhs', rhs')
              with Not_found -> assert false
      end






let rec convert_instr descrs instr = 
  match instr with 
    | Ttree.Nop -> []
    | Ttree.Block instrs -> convert_instrs descrs instrs
    | Ttree.Expr e -> [Expr (convert_expr descrs e)]

    | Ttree.Cond (cond, then_iss, else_iss) ->

        [Cond (
          convert_expr descrs cond,
          convert_instrs descrs then_iss,
          convert_instrs descrs else_iss )]

    | Ttree.Return opt_e -> [Return (map_option (convert_expr descrs) opt_e)]

    | Ttree.Cout [] -> []
    | Ttree.Cout [Ttree.S_expr e] -> [Print_int (convert_expr descrs e)]
    | Ttree.Cout [Ttree.S_string str] -> [Print_string (id_of_string str)]
    | Ttree.Cout (sexpr::next) -> 
        (convert_instr descrs (Ttree.Cout [sexpr])) @ (convert_instr descrs (Ttree.Cout next))

    | Ttree.While (e, is) ->
        [While (convert_expr descrs e, convert_instrs descrs is)]

    | Ttree.For (ies, ec, nes, is) ->
        [For 
            (List.map (convert_expr descrs) ies, 
             convert_expr descrs ec, 
             List.map (convert_expr descrs) nes,
             convert_instrs descrs is
            )] 

    | Ttree.Init_obj (local_id, ctor_id, args) ->

        let lhs = Load_address (mk_lvalue **> Lv_local local_id) in
        let ctor_args = lhs :: (List.map (convert_expr descrs) args) in

        [Expr (Seq (
          (Set_vt (lhs, Smap.find (Typer.class_of_method ctor_id) descrs)),
          (Call (id_of_method ctor_id, ctor_args))
        ))]
        

        
and convert_instrs descrs instrs = List.concat **> List.map (convert_instr descrs) instrs


let choose_local_storage obj_descrs (id, var) = 
  let storage = 
    let var_size = var_size obj_descrs var in
      if (not (Typer.is_num_type var.Ttree.var_ty)) || List.mem id !stacked_locals then 
        Sstack var_size 
      else Sreg
  in 
  (id, storage)
  
let choose_arg_storage (id, _) =
  if List.mem id !stacked_args then (id, Sstack word_size) else (id, Sreg)



let add_proc tprog id proc prog = 

  reset_stacked_vars ();

  let body = convert_instrs prog.prog_data.data_obj_descrs proc.Ttree.proc_impl in

  
  let proc' = {
    proc_id = id ;
    proc_locals = List.map (choose_local_storage prog.prog_data.data_obj_descrs) 
      (Smap.bindings proc.Ttree.proc_locals) ;
    proc_args = List.map (choose_arg_storage) proc.Ttree.proc_args ;
    proc_body = body
  } in
  
  { prog with prog_procs = proc' :: prog.prog_procs }


let add_method tprog id meth prog = add_proc tprog id (meth.Ttree.meth_proc) prog 

let new_prog globs ep ods  = {
  prog_data = {
    data_string_consts   = [] ;
    data_globals         = globs ;
    data_obj_descrs      = ods ;
    data_entry_point     = ep ;
  } ;
  prog_procs             = [];
}



let convert_globals obj_descrs globs = 
  Smap.fold (fun name var acc ->
    let size = var_size obj_descrs var in
    (id_of_global_var name, size) :: acc
  ) globs []


let convert_prog tprog =

  let obj_descrs = gen_objects_descriptors tprog in

  let prog = ref 
    (new_prog 
       (convert_globals obj_descrs tprog.Ttree.prog_vars)
       (id_of_proc tprog.Ttree.prog_entry_point)
       (obj_descrs)
    ) 
  in
  
  let add_procs_with_name name pmap = 
    Ttree.Pmap.iter (fun profile proc -> 
      prog := add_proc tprog (id_of_proc (name, profile)) proc !prog ) pmap in

  let add_methods_in_class c cspec =

    let add_methods_with_name name pmap =
      Ttree.Pmap.iter (fun profile meth ->
        prog := add_method tprog (id_of_method (name, profile)) meth !prog ) pmap in


    (* Ajout des constructeurs *)
    Ttree.Pmap.iter (fun profile proc ->
      prog := add_proc tprog (id_of_method (c, profile)) proc !prog ) 
      cspec.Ttree.class_constructors ;

    (* Ajout des méthodes *)
    Smap.iter add_methods_with_name cspec.Ttree.class_methods 
  in

  Smap.iter add_procs_with_name tprog.Ttree.prog_procs ;
  Smap.iter (fun c cspec -> add_methods_in_class c cspec) tprog.Ttree.prog_classes ;

  prog := {!prog with prog_data = 
      {!prog.prog_data with data_string_consts = Idmap.bindings !string_consts}} ;

  !prog 
