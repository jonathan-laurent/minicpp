(* TYPER.ML
   Analyse sémantique et typage
*)

open Utils
open Enums
open Error
open Loc
open Printf
open Ttree

module Fresh = Fresh.Make(struct end)



let error err = Error.error err Loc.dummy_loc

let rec string_of_type = function
  | Tnull -> "NULL"
  | Tint -> "int"
  | Tvoid -> "void"
  | Tclass name -> name 
  | Tptr ty -> (string_of_type ty) ^ "*"

let translate_type ast_ty = 

  let rec aux = function
    | Ast.Tvoid -> Tvoid
    | Ast.Tint -> Tint
    | Ast.Tident id -> Tclass id
    | Ast.Tptr t -> Tptr (aux t)
    | Ast.Tref _ -> error **> Invalid_type

  in match ast_ty with
    | Ast.Tref t -> {var_ty = aux t ; var_by_ref = true}
    | _ -> {var_ty = aux ast_ty ; var_by_ref = false}


let string_of_profile p = "(" ^ 
  (String.concat ", " **> List.map string_of_type p) ^ ")"


let empty_prog = {
  prog_vars = Smap.empty;
  prog_classes = Smap.empty;
  prog_procs = Smap.empty;
  prog_entry_point = ("main", []);
  prog_classes_order = [];
    
}

let new_proc ret args = {
  proc_args = args ;
  proc_ret = ret ;
  proc_locals = Smap.empty ;
  proc_impl = []
}


let resolve_class prog class_name =
  try Smap.find class_name prog.prog_classes
  with Not_found -> error (Unknown_class class_name)

let extract_ptr = function
  | Tptr ty -> ty
  | _ -> assert false

let extract_class_name = function 
  | Tclass s -> s 
  | _ as ty -> error (Expected_object (string_of_type ty)) 

let class_name_of_profile p = extract_class_name **> extract_ptr **> List.hd p

let change_class_name_in_profile c p = (Tptr (Tclass c)) :: (List.tl p)

let class_of_method (_, p) = class_name_of_profile p



let rec is_sub_class prog c1 c2 = 
  c1 = c2 ||
  let c1_spec = resolve_class prog c1 in
  List.exists (fun c -> is_sub_class prog c c2) (c1_spec.class_supers)


(* Attention : si A hérite de B, A** n'est pas un sous-type de B** *)
let is_sub_type prog ty1 ty2 = 
  let rec aux pl ty1 ty2 = match ty1, ty2 with
    | Tnull, Tptr _ | Tint, Tint -> true
    | Tptr sty1, Tptr sty2 -> aux (pl + 1) sty1 sty2
    | Tclass c1, Tclass c2 -> (is_sub_class prog c1 c2) && pl <= 1
    | _ -> false
  in
  aux 0 ty1 ty2



let rec is_sub_profile prog p1 p2 = match (p1, p2) with
  | [], [] -> true
  | [], _ | _, [] -> false
  | h1::t1, h2::t2 ->  (is_sub_profile prog t1 t2) && (is_sub_type prog h1 h2)

(* Teste si p1 <= p2 avec hd p1 = hd p2 *)
let rec is_sub_args_profile prog p1 p2 =
  let class1 = class_name_of_profile p1
  and class2 = class_name_of_profile p2  in
  class1 = class2 && is_sub_profile prog (List.tl p1) (List.tl p2)

let is_num_type = function 
  | Tnull | Tint | Tptr _ -> true
  | _ -> false







module Resolver = Resolver.Make(Profile)

type resolver = {
  res_meths : Resolver.t Smap.t ;  
  res_procs : Resolver.t Smap.t ;
  res_ctors : Resolver.t Smap.t ;
  res_attrs : Resolver.t Smap.t ;
}

let empty_resolver = {
  res_attrs = Smap.empty;
  res_ctors = Smap.empty;
  res_meths = Smap.empty;
  res_procs = Smap.empty 
}


(* Detects redefinitions and add to the resolving database *)

let resolver_add get set prog name profile resolver  = 

  let sub_res' = 
    let already_defined = 
      try Smap.find name (get resolver)
      with Not_found -> Resolver.empty in

    if Resolver.mem profile already_defined then 
      (error **> Already_defined name) ;

    let defined = Resolver.add (is_sub_profile prog) profile already_defined in
    Smap.add name defined (get resolver)

  in set sub_res' resolver


let resolver_add_ctor = 
  resolver_add (fun r -> r.res_ctors) (fun x r -> {r with res_ctors = x})
let resolver_add_attr = 
  resolver_add (fun r -> r.res_attrs) (fun x r -> {r with res_attrs = x})
let resolver_add_meth = 
  resolver_add (fun r -> r.res_meths) (fun x r -> {r with res_meths = x})
let resolver_add_proc = 
  resolver_add (fun r -> r.res_procs) (fun x r -> {r with res_procs = x})



let resolve_proc prog resolver proc_name args_profile =
  let matched_profile =
    try Resolver.resolve (is_sub_profile prog) args_profile 
          (Smap.find proc_name resolver.res_procs)
    with 
      | Not_found -> error **> Unknown_proc_name proc_name
      | Resolver.No_match -> error **> Profile_no_match 
          (proc_name ^ string_of_profile args_profile)
      | Resolver.Conflict l -> error **> Profile_conflict 
          (proc_name ^ string_of_profile args_profile, 
           List.map string_of_profile l)  
  in
  let proc_spec = 
    (Pmap.find matched_profile 
       (Smap.find proc_name prog.prog_procs)) in

  matched_profile, proc_spec



let resolve_ctor prog resolver ctor_name args_profile =
  let profile = (Tptr (Tclass ctor_name)) :: args_profile in
  let matched_profile = 
    try Resolver.resolve (is_sub_args_profile prog) profile 
          (Smap.find ctor_name resolver.res_ctors)
    with 
        (* TODO : de meilleures erreurs *)
      | Not_found -> error **> Unknown_proc_name ctor_name
      | Resolver.No_match -> error **> Profile_no_match 
          (ctor_name ^ string_of_profile args_profile)
      | Resolver.Conflict l -> error **> Profile_conflict 
          (ctor_name ^ string_of_profile args_profile, 
           List.map string_of_profile l)  
  in
  let matched_class_name = class_name_of_profile matched_profile in
  let matched_class_spec = resolve_class prog matched_class_name in
  
  let ctor_spec = Pmap.find matched_profile 
                    (matched_class_spec.class_constructors) in

  matched_profile, ctor_spec
  

let handle_scope prog lhs_class_name = function
  | None -> false, lhs_class_name
  | Some scoped_class_name -> 
      if not (is_sub_class prog lhs_class_name scoped_class_name) then
        error **> Expected_type (scoped_class_name, lhs_class_name)
      else true, scoped_class_name


let resolve_meth prog resolver lhs_class_name scope meth_name args_profile = 

  let scoped, class_name = handle_scope prog lhs_class_name scope in
  let profile = (Tptr (Tclass class_name)) :: args_profile in

  let matched_profile = 
    try 
      Resolver.resolve 
        ((if scoped then is_sub_args_profile else is_sub_profile) prog) 
        profile (Smap.find meth_name resolver.res_meths)
    with 
      | Not_found -> 
          error (Unknown_meth_name (lhs_class_name ^ "::" ^ meth_name))
      | Resolver.No_match -> error **> Profile_no_match 
          (class_name ^ "::" ^ meth_name ^ string_of_profile (List.tl profile))
      | Resolver.Conflict l -> error **> Profile_conflict 
          (class_name ^ "::" ^ meth_name ^ string_of_profile (List.tl profile), 
           List.map (fun p -> string_of_profile (List.tl p)) l)       
  in 
  let matched_class_name = class_name_of_profile matched_profile in
  let matched_class_spec = resolve_class prog matched_class_name in
  
  let meth_spec = Pmap.find matched_profile 
                    (Smap.find meth_name matched_class_spec.class_methods) in
  
  meth_spec, matched_profile



let resolve_attr prog resolver lhs_class_name scope attr_name =

  let scoped, class_name = handle_scope prog lhs_class_name scope in
  let profile = [Tclass class_name] in
  let matched_profile = 
    try Resolver.resolve 
          ((if scoped then is_sub_args_profile else is_sub_profile) prog)
          profile (Smap.find attr_name resolver.res_attrs)
    with 
      | Not_found -> error (Unknown_attr_name attr_name)
      | Resolver.No_match -> error **> 
          Unknown_attr_name attr_name
      | Resolver.Conflict l -> error **> 
          Profile_conflict (string_of_profile (List.tl profile), 
                            List.map (fun p -> string_of_profile p) l)       
        
  in
  let matched_class_name = extract_class_name (List.hd matched_profile) in
  let matched_class_spec = resolve_class prog matched_class_name in
  let attr_var = Smap.find attr_name matched_class_spec.class_attributes in 
  attr_var, matched_class_name
  





(* Fonctions utilitaires permettant de donnée des noms différents aux variables
   locales de même nom de portée disjointe *)

let decorate_name name occ = 
  if occ >= 1 then sprintf "%s%s%i" name Utils.mips_id_separator occ 
  else name

let rec name_occ name = function
  | [] -> raise Not_found
  | d :: ds ->
      try Smap.find name d
      with Not_found -> name_occ name ds

let add_name name occ = function
  | [] -> assert false
  | d::ds -> (Smap.add name occ d)::ds

let new_occ name = function
    | [] -> assert false
    | block_names::old_names -> 
        if Smap.mem name block_names then error (Already_defined_local name)
        else Fresh.get ()





 



let explicit_this loc qid = setloc loc **> 
  Ast.Member (setloc loc **> Ast.Unary_op (Unref, setloc loc **> Ast.This), qid)



let mk_expr ty expr = {expr_value = expr ; expr_lval = false ; expr_ty = ty}
let mk_lexpr ty expr = {(mk_expr ty expr) with expr_lval = true}

let mk_rlexpr var expr = 
  let e = mk_lexpr var.var_ty expr in
  if var.var_by_ref then 
    mk_lexpr var.var_ty (Implicit_op (Ref_unref, e))
  else e

(* Pour le type de retour d'une fonction *)
let mk_ret_expr var expr =
  if var.var_by_ref then 
    mk_rlexpr var expr
  else mk_expr var.var_ty expr

let ref_init var_arg expr_init = 
  if var_arg.var_by_ref then
    begin
      if not (expr_init.expr_lval) then error Expected_lvalue
      else
        mk_lexpr var_arg.var_ty **> Implicit_op (Ref_addr, expr_init)
    end
  else expr_init


let explicit_cast te1 te2 expr = match te1, te2 with
  | Tptr (Tclass c1), Tptr (Tclass c2) | Tclass c1, Tclass c2 ->
      mk_expr te1 (Implicit_op (Cast (c2, c1), expr))
  | _ -> expr
  

let convert_args proc_spec targs =
  let formals = List.map snd proc_spec.proc_args in
  List.map (fun (f, a) -> 
    explicit_cast f.var_ty a.expr_ty (ref_init f a)) 
    (Utils.zip formals targs)

(* Ignore le pointeur "this" en tête des arguments formels *)
let convert_tail_args proc_spec targs =
  let formals = List.tl **> List.map snd proc_spec.proc_args in

  List.map (fun (f, a) -> 
    explicit_cast f.var_ty a.expr_ty (ref_init f a)) 
    (Utils.zip formals targs)

  




let rec type_expr prog resolver enclosing_proc names ast_expr = 

  let type_expr' = type_expr prog resolver enclosing_proc names in
  let locals = enclosing_proc.proc_locals in

  let eproc_is_method = 
    List.mem "this" (List.map fst enclosing_proc.proc_args) in

  try match ast_expr.value with

  | Ast.Const Null -> mk_expr Tnull (Const Null)
  | Ast.Const e -> mk_expr Tint (Const e)
      
  | Ast.This -> 
      ( try type_expr' (setloc ast_expr.loc (Ast.Qident ("this", None)))
        with Error (Unbound_id "this", _) -> error Unexpected_this )


  | Ast.Qident (name, scope) ->

      ( match scope with
        | None -> (
          
          (* Une variable locale *)
          try
              let name' = decorate_name name (name_occ name names) in
              let var = Smap.find name' locals in
              mk_rlexpr var (Local_var name')

          with Not_found -> (

          (* Un argument de la fonction englobante *)
          try  mk_rlexpr (List.assoc name enclosing_proc.proc_args) 
                 (Argument name)
          with Not_found -> (


          (* Un attribut de "this" *)
          try if eproc_is_method then
            let ast_expr' = explicit_this ast_expr.loc (name, None) in 
            type_expr' ast_expr'
            else raise Not_found

          with Not_found | Error _ -> (


          (* Une variable globale  *)
          try  mk_lexpr (Smap.find name prog.prog_vars).var_ty (Global_var name)
          with Not_found -> error (Unbound_id name) ))))

        | Some class_name -> (

          (* Un attribut de "this" avec indication de portée *)
          try 
            let ast_expr' = explicit_this ast_expr.loc (name, scope) in 
            type_expr' ast_expr'
          with Not_found -> error (Unbound_id name) )
        
      )


  | Ast.Unary_op (op, ast_expr) ->
      let texpr = type_expr' ast_expr in
      let ty = texpr.expr_ty in
      
      let mk_op ty = mk_expr ty (Unary_op (op, texpr)) in
      let mk_lop ty = {(mk_op ty) with expr_lval = true} in

      ( match op, ty with
        | Addr, _ -> 
            if texpr.expr_lval then mk_op (Tptr ty) 
            else error **> Expected_lvalue
        | Unref, Tptr ty' -> mk_lop ty'
        | Unref, _ -> error **> Expected_ptr (string_of_type ty)
        | Not, _ | Unary_plus, _ | Unary_minus, _ -> 
            if ty = Tint then mk_op ty 
            else error **> Expected_int (string_of_type ty)

        | Incr_suf, _ | Decr_suf, _ | Incr_pre, _ | Decr_pre, _ -> 
            if ty <> Tint then error **> Expected_int (string_of_type ty)
            else if not texpr.expr_lval then error **> Expected_lvalue
            else mk_op ty
      )

  | Ast.Binary_op (op, e1, e2) ->
      let te1 = type_expr' e1 and te2 = type_expr' e2 in
      let mk_op ty = mk_expr ty (Binary_op (op, te1, te2)) in
      
      ( match op with

        (* L'initialisation d'une référence est traitée par 
           la construction Init_ref et non ici *)
        | Assign -> 
            if not (is_sub_type prog te2.expr_ty te1.expr_ty) then 
              error **> Expected_type 
                (string_of_type te1.expr_ty, string_of_type te2.expr_ty)
            else if not te1.expr_lval then error **> Expected_lvalue
            else if not (is_num_type te2.expr_ty) then 
              error **> Expected_num_type (string_of_type te2.expr_ty)

            else mk_expr te1.expr_ty 
              (Binary_op (op, te1, explicit_cast te1.expr_ty te2.expr_ty te2))

        | Eq | Neq -> 
            if not (is_num_type te1.expr_ty && is_num_type te2.expr_ty) then 
              error **> Expected_num_type (string_of_type **> 
                (if is_num_type te1.expr_ty then te2 else te1).expr_ty)
            else mk_op Tint 

        | Lt | Leq | Gt | Geq | Plus | Minus | Mul | Div | Mod | And | Or ->
            if not (te1.expr_ty = Tint && te2.expr_ty = Tint) then error **>
              Expected_int (string_of_type **>
                 (if te1.expr_ty = Tint then te2 else te1).expr_ty)

            else mk_op Tint
      )

  (* Un attribut -- ne peux pas être de type référence en minic++*)
  | Ast.Member (e, (attr_name, scope)) -> 
      let te = type_expr' e in
      let lhs_class_name = extract_class_name te.expr_ty in
      let attr_var, matched_class_name = resolve_attr prog resolver 
        lhs_class_name scope attr_name in

      mk_lexpr (attr_var.var_ty) 
        (Attribute (te, (matched_class_name, attr_name)))

  | Ast.New (ctor_name, args) -> 
      let targs = List.map type_expr' args in
      let args_profile = List.map (fun te -> te.expr_ty) targs in
      let matched_profile, ctor_spec = resolve_ctor prog resolver 
        ctor_name args_profile in

      let targs = convert_tail_args ctor_spec targs in
        
      mk_expr (Tptr (Tclass ctor_name)) 
        (New ((ctor_name, matched_profile), targs))

  | Ast.Call (e, args) -> 
      let targs = List.map type_expr' args in
      let args_profile = List.map (fun te -> te.expr_ty) targs in
      ( match e.value with

        | Ast.Qident (name, scope) ->  (

          (* Une méthode de "this" *)
          try
              let ast_member = explicit_this ast_expr.loc (name, scope) in
              let ast_expr' = 
                setloc ast_expr.loc **> Ast.Call (ast_member, args) in

              type_expr' ast_expr'

          with Not_found  | Error(_, _)  -> (
              

          (* Un appel à une procédure globale *)
          try
              if scope <> None then error (Unexpected_scope)
              else
                let targs = List.map type_expr' args in
                let args_profile = List.map (fun te -> te.expr_ty) targs in
                let matched_profile, proc_spec = resolve_proc prog resolver 
                  name args_profile in

                let targs = convert_args proc_spec targs in

                mk_ret_expr proc_spec.proc_ret (Call (
                  (name, matched_profile), targs))
         

          with Not_found | Error (Profile_no_match _, _) -> 
            error (Unbound_id name) ))

            
        (* A method call *)
        | Ast.Member (e, (meth_name, scope)) ->
            
            let te = type_expr' e in
            let lhs_class_name = extract_class_name te.expr_ty in
            let meth_spec, matched_profile = resolve_meth prog resolver 
              lhs_class_name scope meth_name args_profile in 

            let te_targs = convert_args meth_spec.meth_proc (te::targs) in
            let te = List.hd te_targs and targs = List.tl te_targs in


            (* On regarde si la méthode appelée est virtuelle *)
            
            let res = ( match meth_spec.meth_virt with
              | Some virt_repr when scope = None -> 
                  Call_virt (te, virt_repr, targs) 
              | _ -> Call_meth (te, (meth_name, matched_profile), targs) ) in


            mk_ret_expr meth_spec.meth_proc.proc_ret res
              
        | _ -> error Expected_proc 
            
      )      

  with Error (e, _) -> Error.error e ast_expr.loc






(* On transforme : "int i = 3" en "int i; i = 3"  ou "A a" en "A a = A();" *)
let desugar_var_init loc id var var_init = 
  let setloc x = Loc.setloc loc x in 
  match var_init with

    | Ast.Init_empty -> 
        ( match var.var_ty with
          | Tclass class_name -> setloc **> Ast.Init_obj (id, class_name, [])
          | _ -> setloc Ast.Nop
        ) 

    | Ast.Init_expr e -> setloc **> 
        if var.var_by_ref then
          Ast.Init_ref (id, e)
        else
          Ast.Expr (setloc **> Ast.Binary_op 
                      (Assign, (setloc **> Ast.Qident (id, None)), e))
    | Ast.Init_constructor (ctor, args) -> setloc **>
        Ast.Init_obj (id, ctor, args)




let cons_tinstrs tinstr (eproc, names, tinstrs) = 
  (eproc, names, tinstr @ tinstrs)

let group_tinstrs (eproc, names, tinstrs) = (eproc, names, [Block tinstrs])

let get_tinstrs (eproc, names, tinstrs) = tinstrs

let new_block names = Smap.empty :: names
let end_block (eproc, names, tinstrs) = 
  try (eproc, List.tl names, tinstrs) 
  with _ -> assert false

let check_int te = if te.expr_ty <> Tint then 
    error **> Expected_int (string_of_type te.expr_ty)


(* Retourne de nouvelles versions de [eproc] et [names], 
   ainsi qu'une liste contenant les instructions correspondantes *)
let rec type_instr prog resolver eproc names instr = 

  let same_state tinstrs = (eproc, names, tinstrs) in 
  let type_expr' = type_expr prog resolver eproc names in
  let type_instr' = type_instr prog resolver eproc names in

  try match instr.value with

    | Ast.Nop -> same_state [Nop]

    | Ast.Block instrs -> end_block **> 
        type_instrs prog resolver eproc (new_block names) instrs

    | Ast.Expr e -> same_state **> [Expr (type_expr' e)]

    | Ast.Decl_locals [] -> same_state []

    | Ast.Decl_locals (((ast_ty, name), var_init) :: decls) ->

        let var = translate_type ast_ty in    
        let occ = new_occ name names in
        let name' = decorate_name name occ in

        if var.var_ty = Tvoid then error **> Illegal_void ;

        let (eproc', names', tinstrs) = 

          type_instr prog resolver
            { eproc with proc_locals = Smap.add name' var eproc.proc_locals }
            ( add_name name occ names )
            ( desugar_var_init instr.loc name var var_init ) in


        let ast_expr' = setloc instr.loc **> Ast.Decl_locals decls in
        cons_tinstrs tinstrs (type_instr prog resolver eproc' names' ast_expr')


    | Ast.Init_obj (name, ctor_name, args) -> 

        let name' = decorate_name name (name_occ name names) in
        let ty = (Smap.find name' eproc.proc_locals).var_ty in
        if ty <> (Tclass ctor_name) then error **> Wrong_initialisation;
        let targs = List.map type_expr' args in
        let args_profile = List.map (fun te -> te.expr_ty) targs in
        let matched_profile, ctor_spec = 
          resolve_ctor prog resolver ctor_name args_profile in
        let targs = convert_tail_args ctor_spec targs in
        same_state **>  [Init_obj (name', (ctor_name, matched_profile), targs)]

    (* Une variable locale est initialisée comme une référence  *)
    | Ast.Init_ref (name, e) ->

        let name' = decorate_name name (name_occ name names) in
        let lhs_ty = (Smap.find name' eproc.proc_locals).var_ty in
        let rhs = type_expr' e in

        if not (is_sub_type prog rhs.expr_ty lhs_ty) then error **> 
          Expected_type (string_of_type lhs_ty, string_of_type rhs.expr_ty) ;

        if not rhs.expr_lval then error **> Expected_lvalue ;

        let assignment = mk_expr Tvoid 
          (Binary_op (Assign, 
                      mk_lexpr lhs_ty (Local_var name'),
                      explicit_cast lhs_ty rhs.expr_ty (
                        mk_lexpr rhs.expr_ty (Implicit_op (Ref_addr, rhs)))
           )) in

        same_state **> [Expr assignment]


    | Ast.Cond (e_cond, i_then, option_i_else) ->
        let ast_nop = setloc instr.loc **> Ast.Nop in
        let te_cond = type_expr' e_cond in
        let eproc', _, ti_then =  type_instr' i_then  in
        let eproc'', _, ti_else = type_instr prog resolver eproc' names 
          (get_option ast_nop option_i_else) in

        check_int te_cond ;
        (eproc'', names, [Cond (te_cond, ti_then, ti_else)])

    | Ast.While (e_cond, i_loop) -> 
        let te_cond = type_expr' e_cond 
        and eproc', _, ti_loop = type_instr' i_loop in

        check_int te_cond ;
        (eproc', names, [While (te_cond, ti_loop)])

    | Ast.For (es_init, option_e_cond, es_next, i_loop) ->
        let ast_true = setloc instr.loc **> Ast.Const True in
        let tes_init = List.map type_expr' es_init 
        and te_cond = type_expr' (get_option ast_true option_e_cond)
        and tes_next = List.map type_expr' es_next
        and eproc', _, ti_loop = type_instr' i_loop in

        check_int te_cond;
        (eproc', names, [For (tes_init, te_cond, tes_next, ti_loop)])

    | Ast.Cout (str_exprs) ->

        let type_str_expr = function
          | Ast.S_expr e -> let te = type_expr' e in check_int te ; S_expr te
          | Ast.S_string s -> S_string s in

        same_state **> [Cout (List.map type_str_expr str_exprs)]

    | Ast.Return (Some e) ->
        let te = type_expr' e in 
        let expected_var = eproc.proc_ret and ty = te.expr_ty in
        if not (is_sub_type prog ty expected_var.var_ty) then
          error **> Expected_type (
            string_of_type expected_var.var_ty, string_of_type ty) ;

        let te = ref_init expected_var te in
        let te = explicit_cast expected_var.var_ty ty te in

        same_state **> [Return (Some te)]

    | Ast.Return (None) -> same_state **> [Return (None)]

  with Error(e, loc) -> 
    let loc' = if loc = dummy_loc then instr.loc else loc in
    Error.error e loc'



and type_instrs prog resolver eproc names = function
  | [] -> (eproc, names, [])
  | instr::next_instrs -> 
      let (eproc', names', tinstrs) = 
        type_instr prog resolver eproc names instr in
      cons_tinstrs tinstrs (type_instrs prog resolver eproc' names' next_instrs)







let is_available_name prog name = not (
     Smap.mem name prog.prog_vars 
  || Smap.mem name prog.prog_classes 
  || Smap.mem name prog.prog_procs )

let is_available_proc_name prog name = not (
     Smap.mem name prog.prog_vars 
  || Smap.mem name prog.prog_classes )

  

let add_global (prog, resolver) (ast_ty, name) = 

  if not **> is_available_name prog name then error **> Already_defined name ;

  let var = translate_type ast_ty in
  if Smap.mem name prog.prog_vars then error **> Already_defined name ;
  if var.var_ty = Tvoid then error **> Illegal_void ;
  let prog' = {prog with prog_vars = Smap.add name var prog.prog_vars} in
  (prog', resolver)



let fun_dict_mem name profile dict =
  try Pmap.mem profile (Smap.find name dict)
  with Not_found -> false


let fun_dict_add name profile el dict = 
  let pmap = 
    try Smap.find name dict
    with Not_found -> Pmap.empty in
  Smap.add name (Pmap.add profile el pmap) dict


let fun_dict_find name profile dict = Pmap.find profile (Smap.find name dict)

let prog_add_proc name profile descr prog =
  { prog with prog_procs = fun_dict_add name profile descr prog.prog_procs }
  
let handle_args args = 
  let targs = List.map (fun (ty, ident) -> (ident, translate_type ty)) args in

  if not (all_different **> List.map fst targs) then 
    error Many_uses_of_arg_name ; 
  if List.exists (fun (_, var) -> var.var_ty = Tvoid) targs then 
    error **> Illegal_void ;

  let args_profile = List.map (fun (_, ast_var) -> ast_var.var_ty) targs in 
  targs, args_profile


let handle_args_adding_this_ptr class_name args =
  let targs, args_profile = handle_args args in
  ("this", {var_by_ref = false ; var_ty = Tptr (Tclass class_name)}) :: targs, 
  (Tptr (Tclass class_name)) :: args_profile



let type_impl prog resolver proc_spec instr = 
  Fresh.reset ();
  type_instr prog resolver proc_spec [] instr
  

let rename_method_args ast_args proc_spec = 
  {proc_spec with proc_args = List.hd proc_spec.proc_args ::
      ( List.map 
         (fun ((_, var), (_, name)) -> (name, var)) 
         (zip (List.tl proc_spec.proc_args) ast_args))
  }


  
let call_supers_default_ctor class_name supers = List.map (fun super -> 

  let this_ptr = mk_lexpr (Tptr (Tclass super)) **>
    Implicit_op (
      Cast (class_name, super), mk_lexpr (Tptr (Tclass class_name)) **> 
        (Argument "this")) in

  Expr (mk_expr Tvoid **> Call_meth (
    this_ptr, (super, [Tptr (Tclass super)]), 
    []))

) supers




let add_impl (prog, resolver) (prototype, instr) = match prototype with

  | Ast.Function_prototype ((ret_ty, (name, scope)), args) ->

      let targs, args_profile = handle_args args in   

      ( match scope with

        (* Une declaration et implementation de fonction globale *)
        | None ->

            if not **> is_available_proc_name prog name then 
              error **> Already_defined name ;

            let proc_spec = new_proc (translate_type ret_ty) targs in

            let prog' = {prog with prog_procs = 
                fun_dict_add name args_profile proc_spec prog.prog_procs} in

            let resolver' = resolver_add_proc 
              prog' name args_profile resolver in

            let proc_spec', _, tinstrs = 
              type_impl prog' resolver' proc_spec instr in

            let proc_spec'' = {proc_spec' with proc_impl = tinstrs} in

            ( {prog' with prog_procs = 
                fun_dict_add name args_profile proc_spec'' prog'.prog_procs}, 
              resolver')


        (* Implémentation d'une méthode déjà déclarée *)
        | Some class_name ->

            let class_spec = resolve_class prog class_name in
            let profile = (Tptr (Tclass class_name)) :: args_profile in

            (* TODO : meilleure erreur *)
            let meth_spec = 
              try fun_dict_find name profile class_spec.class_methods 
              with Not_found -> error **> Unknown_meth_name name in

            (* Cette méthode a déjà été implémentée *)
            if meth_spec.meth_proc.proc_impl <> [] then 
              error **> Already_defined_proc name ;

            let proc_spec = rename_method_args args meth_spec.meth_proc in
            let proc_spec, _, tinstrs = 
              type_impl prog resolver proc_spec instr in
            
            let proc_spec = {proc_spec with proc_impl = tinstrs} in
            
            let meth_spec = {meth_spec with meth_proc = proc_spec} in
            let class_spec = 
              { class_spec with class_methods = 
                  fun_dict_add name profile meth_spec class_spec.class_methods }
            in

            ( {prog with 
              prog_classes = Smap.add class_name class_spec prog.prog_classes}, 
              resolver)

      )

  | Ast.Constructor_prototype (class_name, args) -> 

      let targs, profile = handle_args_adding_this_ptr class_name args in
      let class_spec = resolve_class prog class_name in

      let ctor_spec = try Pmap.find profile class_spec.class_constructors
        with Not_found -> error **> Unknown_ctor_name class_name in

      if ctor_spec.proc_impl <> [] then error **> Already_defined class_name;

      let ctor_spec = rename_method_args args ctor_spec in
      let ctor_spec, _, tinstrs = type_impl prog resolver ctor_spec instr in

      let proc_impl_intro = 
        call_supers_default_ctor class_name class_spec.class_supers in

      let ctor_spec = {ctor_spec with proc_impl = proc_impl_intro @ tinstrs} in
      
      let class_spec = 
        { class_spec with class_constructors = 
            Pmap.add profile ctor_spec class_spec.class_constructors } in

      ( {prog with prog_classes = 
          Smap.add class_name class_spec prog.prog_classes}, 
        resolver )

   
let dummy_meth_id = ("", []) 



let merge_supers_virts prog supers = 
  let merge_dicts old new_dict = 
    Vsmap.fold (fun k v dict -> 
      if Vsmap.mem k old then old else Vsmap.add k v dict) 
      new_dict old 
  in
  List.fold_left (fun virts super -> 
    merge_dicts virts (resolve_class prog super).class_overridings) 
    Vsmap.empty supers


let add_class (prog, resolver) decl_class = 

  let class_name = decl_class.Ast.class_name in
  let supers = decl_class.Ast.class_supers in

  if not **> is_available_name prog class_name then 
    error **> Already_defined class_name ;

  let class_spec = {
    class_supers = supers;
    class_methods = Smap.empty;
    class_attributes = Smap.empty;
    class_constructors = Pmap.empty;
    class_overridings = merge_supers_virts prog supers;
    class_new_virts = [] ;

  } in
  
  if Smap.mem class_name prog.prog_classes then 
    error **> Already_defined class_name ;

  let prog = {prog with prog_classes = 
      Smap.add class_name class_spec prog.prog_classes} in


  let add_attribute (class_spec, resolver) (ast_ty, name) = 

    let ty = translate_type ast_ty in
    let profile = [Tclass class_name] in

    if ty.var_ty = Tvoid then error **> Illegal_void ;
    if ty.var_ty = (Tclass class_name) then 
      error **> Recursive_class_def class_name ;
    if ty.var_by_ref then error **> Attribute_is_ref name ;

    let class_spec' = 
      {class_spec with 
        class_attributes = Smap.add name ty class_spec.class_attributes} in

    let resolver' = resolver_add_attr prog name profile resolver in
    (class_spec', resolver')

  in


  let add_method (class_spec, resolver) virt ret_ty name args = 

    let ret = translate_type ret_ty in
    let targs, profile = handle_args_adding_this_ptr class_name args in 
    let method_id = (name, profile) in

    let method_spec = {
      meth_virt = None ;
      meth_proc = new_proc ret targs
    } in

    let resolver = resolver_add_meth prog name profile resolver in


    (* Gestion des méthodes virtuelles *)
    let method_spec, class_overridings, class_new_virts  = 
      let virt_id = (name, List.tl profile) in
      try 

        (* La méthode est une redéfinition d'une méthode virtuelle *)
        let matching_repr, matching_ret, _ = 
          Vsmap.find virt_id class_spec.class_overridings in

        if matching_ret <> ret then error **> Virtual_different_ret_ty else
          
          { method_spec with meth_virt = Some matching_repr}, 
          Vsmap.add virt_id (matching_repr, ret, method_id) 
            class_spec.class_overridings,
          class_spec.class_new_virts
            
      with Not_found ->
        if virt then 

          {method_spec with meth_virt = Some method_id}, 
          Vsmap.add virt_id (method_id, ret, method_id) 
            class_spec.class_overridings, 
          class_spec.class_new_virts @ [virt_id]

        else 
          method_spec, class_spec.class_overridings, class_spec.class_new_virts 
    in

    
    let class_spec = {class_spec with 
      class_overridings = class_overridings; 
      class_new_virts = class_new_virts;
      class_methods = 
        fun_dict_add name profile method_spec class_spec.class_methods
    }

    in (class_spec, resolver)

  in

  let add_ctor (class_spec, resolver) args = 

    let targs, profile = handle_args_adding_this_ptr class_name args in
    let ret = {var_by_ref = false ; var_ty = Tclass class_name} in    
    let proc_spec = new_proc ret targs in 

    let class_spec' = {class_spec with class_constructors =
        Pmap.add profile proc_spec class_spec.class_constructors } in

    let resolver' = resolver_add_ctor prog class_name profile resolver in
    (class_spec', resolver')

  in

  let add_member st decl = 
    try match decl.value with
      | Ast.Attributes attrs -> List.fold_left add_attribute st attrs
      | Ast.Prototype (virt_opt, proto) ->
          ( match proto with
            | Ast.Function_prototype ((ret_ty, (name, scope)), args) -> 
                if scope <> None then error Unexpected_scope ;
                add_method st (virt_opt = Ast.Virtual) ret_ty name args
            | Ast.Constructor_prototype (name, args) ->
                if virt_opt = Ast.Virtual then error **> Unexpected_virtual ;
                if name <> class_name then error Lacks_ret_ty;
                add_ctor st args
          )
    with 
      | Error(e, loc) -> 
          let loc' = if loc = dummy_loc then decl.loc else loc in
          Error.error e loc'

  in 


  let add_default_ctor (class_spec, resolver) =
    if Pmap.is_empty class_spec.class_constructors then

      let ret = {var_ty = Tclass class_name ; var_by_ref = false} in
      let targs, profile = handle_args_adding_this_ptr class_name [] in
      let proc_spec = new_proc ret targs in

      let proc_impl = 
        call_supers_default_ctor class_name class_spec.class_supers in

      let proc_spec = {proc_spec with proc_impl = proc_impl} in

      let class_spec' = {class_spec with class_constructors =
          Pmap.add profile proc_spec class_spec.class_constructors } in

      let resolver' = resolver_add_ctor prog class_name profile resolver in
      (class_spec', resolver')

    else (class_spec, resolver)
  in


  let class_spec', resolver' = add_default_ctor **>
    List.fold_left add_member (class_spec, resolver) 
    decl_class.Ast.class_members in


  let prog = {prog with 
    prog_classes = Smap.add class_name class_spec' prog.prog_classes;
    prog_classes_order = class_name :: prog.prog_classes_order
  } in

  (prog, resolver')




    

let type_decl st decl = try match decl.value with
  | Ast.Decl_globals ast_vars -> List.fold_left add_global st ast_vars
  | Ast.Decl_impl d -> add_impl st d
  | Ast.Decl_class d -> add_class st d 
  with
    | Error(e, loc) -> 
        let loc' = if loc = dummy_loc then decl.loc else loc in
        Error.error e loc'
      

let check_main_function prog = 

  let name, profile = prog.prog_entry_point in

  try
    let proc_spec = fun_dict_find name profile prog.prog_procs in
    if proc_spec.proc_ret <> {var_by_ref = false; var_ty = Tint} 
    then error **> Invalid_main_ret_ty ;

    {prog with prog_entry_point = (name, profile)}
      
  with Not_found -> error **> No_main_proc
  


let type_ast decls = 
  let prog, resolver = 
    List.fold_left type_decl (empty_prog, empty_resolver) decls in
  check_main_function prog

  
