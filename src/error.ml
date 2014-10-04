(* ERRORS.ML
   Liste des erreurs de compilation et des messages d'erreurs
*)

open Loc
open Printf

type error = 

  | Illegal_character of char
  | Unterminated_comment

  | Parse_error

  | Unexpected_this
  | Unexpected_scope
  | Unexpected_virtual

  | Unbound_id of string

  | Unknown_class of string
  | Unknown_attr_name of string
  | Unknown_ctor_name of string
  | Unknown_proc_name of string
  | Unknown_meth_name of string (* nom de la classe, puis de la méthode *)

  | Profile_no_match of string
  | Profile_conflict of string * (string list)

  | Expected_lvalue
  | Expected_ptr of string
  | Expected_object of string (* type de l'expression fautive *)
  | Expected_proc
  | Expected_type of string * string (* type attendu, type obtenu *)
  | Expected_int of string
  | Expected_num_type of string (* type obtenu *)

  | Lacks_ret_ty
  | Virtual_different_ret_ty
  | Attribute_is_ref of string
  | Invalid_type

  | Already_defined_proc of string
  | Already_defined_local of string
  | Already_defined of string
  | Many_uses_of_arg_name

  | Wrong_initialisation
  | Illegal_void
  | Recursive_class_def of string
  | No_main_proc 
  | Invalid_main_ret_ty
  | Missing_return_statement



let rec error_description = function
  | Illegal_character c -> sprintf "Illegal character \"%c\"" c
  | Unterminated_comment -> "Unterminated comment"

  | Parse_error -> "Parse error"

  | Unexpected_this -> "Unexpected \"this\" pointer"
  | Unexpected_scope -> "Unexpected scope declaration"
  | Unexpected_virtual -> "Unexpected \"virtual\" keyword"

  | Unbound_id s -> sprintf "Unbound identifier \"%s\"" s

  | Unknown_class s -> sprintf "Unknown class name \"%s\"" s
  | Unknown_attr_name s -> sprintf "Unkown attribute \"%s\"" s
  | Unknown_ctor_name s -> sprintf "Unknown constructor name \"%s\"" s
  | Unknown_proc_name s -> sprintf "Unknown procedure name \"%s\"" s
  | Unknown_meth_name s -> sprintf "Unknown method name \"%s\"" s

  | Profile_no_match s -> 
      sprintf "No instance matches \"%s\"" s
  | Profile_conflict (s, l) -> 
      sprintf "Several instances are conflicting which match \"%s\" :\n \"%s\"" s (String.concat " \n " l)

  | Expected_lvalue -> sprintf "A left value was expected"
  | Expected_ptr s -> 
      sprintf  "Expected a pointer instead of an expression whose type is \"%s\"" s
  | Expected_object s -> 
      sprintf "Expected an object instead of an expression whose type is \"%s\"" s
  | Expected_proc -> sprintf "Expected a procedure"
  | Expected_type (s1, s2) -> 
      sprintf "Expected type \"%s\" while received \"%s\"" s1 s2
  | Expected_int s -> error_description (Expected_type ("int", s))
  | Expected_num_type s -> 
      sprintf "Expected a numerical expression while received an expression whose type \"%s\"" s

  | Virtual_different_ret_ty -> "Virtual method overriding with a different return type"
  | Lacks_ret_ty -> sprintf "A method should have a return type"
  | Attribute_is_ref s -> 
      sprintf "The attribute  \"%s\" is a reference and this feature is not supported in minic++" s
  | Invalid_type -> sprintf "Invalid type"

  | Already_defined_proc s -> 
      sprintf "The procedure \"%s\" is already defined" s
  | Already_defined_local s -> 
      sprintf "The local variable  \"%s\" is already defined" s
  | Already_defined s -> sprintf "The identifier \"%s\" is already defined" s
  | Many_uses_of_arg_name -> sprintf "Two arguments are given the same name"

  | Wrong_initialisation -> "Wrong call of a constructor"
  | Illegal_void -> "Illegal use of the \"void\" type"
  | Recursive_class_def s -> sprintf "Recursive class definition \"%s\"" s
  | No_main_proc -> "Missing \"main\" function"
  | Invalid_main_ret_ty -> "The \"main\" function should return an integer"
  | Missing_return_statement -> ""


  (* | _ -> "Not documented error" *)


exception Error of error * loc

let is_conflict_error = function
  | Profile_conflict _ -> true
  | _ -> false

let error err loc = raise (Error (err, loc))

let loc_message loc = 
  Printf.sprintf "File \"%s\", line %d, characters %d-%d:" 
    loc.loc_file
    loc.loc_line
    loc.loc_start_c
    loc.loc_end_c
