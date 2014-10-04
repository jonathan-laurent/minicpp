(* LABEL.ML 
   Génération d'étiquettes uniques pour le module Fgraph
*)

type t = int

let last_label_id = ref 0

let reset_counter () = 
  last_label_id := 0

let fresh () = 
  incr last_label_id ; 
  !last_label_id

let dummy = -1

module Label = struct type t = int let compare = compare end

module M = Map.Make(Label)
module S = Set.Make(Label)
