(* ISTREE.ML

   Au cours de la passe Is conduisant à cette représentation,
   - Des identifiants uniques sont constitués 
   - La couche objet est essentiellement traduite
   - Une grande partie des instructions MIPS finales est sélectionnée
*)

open Utils
open Enums

type offset = int


(* On donne à chaque entité un identifiant unique mais évocateur, de manière
   à faciliter le débogage. 
*)

type id = string

module Idmap = Smap

type proc_id        = id
type vtable_id      = id
type global_id      = id
type string_id      = id

type arg_id         = Ttree.arg_id
type local_id       = Ttree.local_id
type class_id       = Ttree.class_id

type const = string * Enums.base



(* Pour la suite, chaque procédure sera traitée de manière parfaitement 
   indépante et sans accès à [prog_data], qui pourra directement
   servir à générer le segment .data dans le fichier assembleur lors
   de la dernière passe.
*)

type program = {
  prog_procs : proc list ;
  prog_data  : data ;
}

and data = {
  data_string_consts  : (string_id * string) list ;
  data_globals        : (global_id * int) list ;
  data_obj_descrs     : obj_descr Smap.t ;
  data_entry_point    : proc_id ;
}

and vtable = {
  vtable_id           : vtable_id ;
  vtable_class        : class_id ; 

  (* Pour que l'objet puise passer pour un objet de type [vtable_class] *)
  vtable_size         : int ;

  (* class_id pour obtenir plus tard le delta, proc_id : adresse exacte *)
  vtable_contents     : (class_id * proc_id) list ; 
}

and obj_descr = {
  obj_supers_offsets  : offset Smap.t ;
  obj_first_field     : offset ;
  obj_fields          : offset Smap.t ;
  obj_size            : int ;

  obj_vtables         : (offset * vtable) list ;
  obj_virts_offsets   : offset Idmap.t ; 
}




(* Indique pour la suite où une variable doit être placée de préférence *)

and storage = 
  | Sreg                (* Dans un registre *)
  | Sstack of int       (* Sur la pile. Paramètre : taille de la donnée  *)

and proc = {
  proc_id             : proc_id ;
  proc_locals         : (local_id * storage) list ;
  proc_args           : (arg_id * storage) list ;
  proc_body           : instrs
}


(* La correlation avec la même notion au typage n'est pas parfaite
   Ici, une valeur gauche désigne plus simplement un emplacement
   mémoire. Ainsi, tout pointeur peut potentiellement servir de lvalue
*)
and lvalue = lvalue_base * offset

and lvalue_base =
  | Lv_local of local_id
  | Lv_arg of arg_id
  | Lv_global of global_id
  | Lv_ptr of expr

(* Cas d'un opérateur agissant sur une valeur gauche
   -- & est traité à part --  *)
and lunop = Incr_pre | Incr_suf | Decr_pre | Decr_suf

and expr = 
  | Seq of expr * expr
  | Const of const
  | Unop of munop * expr
  | Binop of mbinop * expr * expr
  | Lunop of lunop * lvalue

  | Call of proc_id * (expr list)

  | Load of lvalue
  | Store of expr * lvalue
  | Load_address of lvalue

  | And of expr * expr
  | Or of expr * expr


  (* L'objet sur lequel porte l'appel est donné séparemment des arguments 
     Les décalage passés correspond dans lis'ordre au
     - décalage de la vtable par rapport à lvalue
     - décalage au sein de cette vtable
  *)
  | Vcall of expr * offset * offset * (expr list)

  (* Alloue de l'espace pour un nouvel objet et l'initialise *)
  | New of obj_descr * proc_id * (expr list)

  (* Initialise les tables de méthodes virtuelles d'un objet dont un 
     pointeur est fourni *)
  | Set_vt of expr * obj_descr 


(* L'essentiel des instructions est repris de la passe précédente *)

and instr =
  | Nop
  | Expr of expr
  | Cond of expr * instrs * instrs
  | While of expr * instrs
  | For of (expr list) * expr * (expr list) * instrs
  | Print_string of string_id
  | Print_int of expr
  | Return of expr option


and instrs = instr list


