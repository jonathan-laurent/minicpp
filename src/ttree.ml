(* TTREE.ML
   Arbre de représentation après l'analyse sémantique
*)

open Utils
open Enums

type name = string

and ty = 
  | Tnull
  | Tint
  | Tvoid
  | Tclass of name
  | Tptr of ty

and profile = ty list

and var = {var_ty : ty ; var_by_ref : bool}

and class_id  = name

(* Nom de la procédure, puis profil des arguments *)
and proc_id   = name * profile

(* Nom de la méthode, puis profil des arguments, avec le pointeur "this"
   on peut donc trouver la classe d'origine en consultant la tête du profil *)
and meth_id   = proc_id 
and ctor_id   = name * profile (* idem méthode *)
and attr_id   = name * name (* Nom de la classe, nom de l'attribut *)
and global_id = name
and local_id  = name
and arg_id    = name


(* Représente la signature d'une méthode virtuelle : correspond
   à la valeur meth_id pour une des instances, où le profile est
   tronqué du type de "this" *)
and virt_sig = meth_id

module Profile = struct type t = profile let compare = Utils.list_compare end
module Pmap = Map.Make(Profile) 

module Meth_id = struct type t = meth_id let compare = compare end
module Methmap = Map.Make(Meth_id)

module Proc_id = struct type t = proc_id let compare = compare end
module Procmap = Map.Make(Proc_id)

module Virt_sig = struct type t = virt_sig let compare = compare end
module Vsmap = Map.Make(Virt_sig)


type proc = {
  proc_ret    : var ;
  proc_args   : (name * var) list ;
  proc_locals : var Smap.t ;
  proc_impl   : instrs ;
}

and meth = {
  meth_proc : proc ;

  (* Si la méthode n'est pas virtuelle : None
     Sinon : la référence de la méthode virtuelle la plus générale 
     ainsi redéfinie *)
  meth_virt : meth_id option ; 
}

and program = {
  prog_vars  : var Smap.t ;
  prog_classes : class_spec Smap.t ;
  prog_procs : (proc Pmap.t) Smap.t ;
  prog_entry_point : proc_id ;

  (* Contient la liste des noms de classes, triée par ordre 
     inverse de définition *)
  prog_classes_order : class_id list ;
}


and class_spec = {
  class_supers       : class_id list;
  class_methods      : (meth Pmap.t) Smap.t;
  class_attributes   : var Smap.t;
  class_constructors : proc Pmap.t;


  (* A la signature d'une méthode virtuelle, on associe un triplet comprenant :
     - L'identifiant de la méthode la plus générale 
       correspondant à la signature (le représentant)
     - Le type de retour de cette méthode
     - Lidentifiant de la méthode qui devra être effectivement appelée pour un
       objet de cette classe
  *)
  class_overridings  : (meth_id * var * meth_id) Vsmap.t; 

  (* Liste des méthodes virtuelles définies à partir de cette classe,
     dans l'ordre où nous voulons les voir apparaitre dans la vtable *)
  class_new_virts    : virt_sig list ; 
}


and expr = {expr_value : expr_value ; expr_lval : bool ; expr_ty : ty}
and expr_value = 
  | Const of const

  | Argument   of arg_id
  | Local_var  of local_id
  | Global_var of global_id
  | Attribute  of expr * attr_id

  | Call of proc_id * (expr list)
  | Call_meth of expr * meth_id * (expr list)
  | Call_virt of expr * meth_id * (expr list)

  | New of ctor_id * (expr list)

  | Unary_op of unary_op * expr
  | Binary_op of binary_op * expr * expr
  | Implicit_op of implicit_op * expr


(* Permet de traiter dès le typage l'accès et l'affectation des références,
   ainsi que les casts implicites de pointeurs *)
and implicit_op =
  | Ref_unref (* pour la génération de code, synonyme de * *)
  | Ref_addr (* idem & *)
  | Cast of class_id * class_id (* type du pointeur d'origine, nouveau type *)


and instr = instr_value
and instr_value = 
  | Nop
  | Block of instrs
  | Expr of expr
  | Cond of expr * instrs * instrs
  | While of expr * instrs
  | For of (expr list) * expr * (expr list) * instrs
  | Cout of str_expr list
  | Return of expr option

  (* Initialisation d'un objet local *)
  | Init_obj of local_id * ctor_id * (expr list)

and instrs = instr list

and str_expr = 
  | S_expr of expr 
  | S_string of string



