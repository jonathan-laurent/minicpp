(* TIDENT.ML
   Permet l'interaction entre analyse syntaxique et lexicale
   pour reconnaître les noms de types comme des lexèmes distincts
*)

module Sset = Utils.Sset

let tidents = ref Sset.empty

let reset () = tidents := Sset.empty

let add id = tidents := Sset.add id !tidents

let check id = Sset.mem id !tidents
