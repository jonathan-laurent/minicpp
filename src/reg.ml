(* REG.ML
   Types des registres concrets et abstraits
*)

type real = int

type pseudo = 
  | Pseudo of int
  | Real of real

let is_real = function
  | Real _ -> true
  | _ -> false

let real_of_pseudo = function
  | Real r -> r
  | _ -> assert false


let last_fresh_id = ref 0

let reset_fresh_counter () = 
  last_fresh_id := 0

let fresh () = 
  incr last_fresh_id ; 
  Pseudo !last_fresh_id


let a0 = 4
let a1 = 5
let a2 = 6
let a3 = 7

let v0 = 2
let v1 = 3

let sp = 29
let fp = 30

let ra = 31


(* Couleurs utilisées dans l'allocation de registres *)
let colors = (Utils.range) 4 28


module Pseudo = struct 
  type t = pseudo 
  let compare = compare 

  let ra = Real ra
  let a0 = Real a0
  let sp = Real sp
  let v0 = Real v0

end

module M = Map.Make (Pseudo)
module S = Set.Make (Pseudo)


let all = List.map (fun i -> Real i) (Utils.range 0 31)

let callee_saved = List.map (fun i -> Real i) (Utils.range 16 23)

let caller_saved = Utils.list_diff all callee_saved

let ti = List.map (fun i -> Real i) (Utils.range 8 15)

let params = [Real a0 ; Real a1 ; Real a2 ; Real a3]

let result = Real v0



open Printf 

let name_of_id id = 
  if id >= 4 && id <= 7 then sprintf "$a%d" (id - 4) 
  else if id >= 8 && id <= 15 then sprintf "$t%d" (id - 8)
  else if id >= 16 && id <= 23 then sprintf "$s%d" (id - 16)
  else if id >= 24 && id <= 25 then sprintf "$t%d" (id - 16)
  else match id with
    | 0  -> "$zero"
    | 1  -> "$at"
    | 2  -> "$v0"
    | 3  -> "$v1"
    | 26 -> "$k0"
    | 27 -> "$k1"
    | 28 -> "$gp"
    | 29 -> "$sp"
    | 30 -> "$fp"
    | 31 -> "$ra"
    | _  -> sprintf "r%d" id


let string_of_pseudo = function
  | Real r -> name_of_id r
  | Pseudo i -> sprintf "%%%d" i
