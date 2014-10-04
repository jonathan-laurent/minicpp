(* LOC.ML 
   Permet d'associer à une valeur quelconque une information
   de localisation dans le fichier source
*)

type loc = {
  loc_file : string ;
  loc_line : int ;
  loc_start_c : int ;
  loc_end_c : int
}

type 'a located = {value : 'a ; loc : loc}

let dummy_loc = 
  {loc_file = "" ; loc_line = 0 ; loc_start_c = 0 ; loc_end_c = 0}

let lift f loc_x = {loc = loc_x.loc ; value = (f loc_x.value)}

let setloc loc x = {loc = loc ; value = x}

let loc_of_lexing_pos pos pos_end = 
  let open Lexing in
      { loc_file = pos.pos_fname ;
        loc_line = pos.pos_lnum ;
        loc_start_c = pos.pos_cnum - pos.pos_bol ;
        loc_end_c = pos_end.pos_cnum - pos_end.pos_bol
      }
