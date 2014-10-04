(* UTILS.ML *)

let get_option default = function
  | None -> default
  | Some a -> a

let map_option f = function
  | None -> None
  | Some x -> Some (f x)

let rec find_some = function
  | [] -> raise Not_found
  | None::xs -> find_some xs
  | (Some a)::xs -> a


let ( **> ) f x = f x

let ( % ) g f x = g (f x)

let const x = fun _ -> x

let all_different l = 

  let rec aux = function
    | [] -> true
    | [h] -> true
    | h1::h2::t -> (h1 <> h2) && (aux (h2::t)) 

  in aux (List.sort compare l)

let rec max_list = function
  | [] -> assert false
  | [x] -> x
  | x::xs -> max x (max_list xs)

let rec list_remove e = function
  | [] -> []
  | x::xs -> 
      if x = e then list_remove e xs
      else x::(list_remove e xs)

let list_diff l1 l2 = List.fold_right list_remove l2 l1



module Smap =
struct
  include Map.Make 
    (
      struct
	type t = string
	let compare = compare
      end
    )

  let of_list l =
    List.fold_left (fun env (x, ty) -> add x ty env) empty l

  let union m1 m2 = 
    let merge_fun _ opt1 opt2 = match opt1, opt2 with
      (* Choix arbitraire, à considérer à chaque utilisation *)
      | Some x1, Some x2 -> Some x1
      | Some x1, _ -> Some x1
      | _, Some x2 -> Some x2
      | _ -> None 
    in
    merge merge_fun m1 m2

  let modify name f dict = 
    try add name (f (find name dict)) dict
    with Not_found -> dict

end

module Imap = Map.Make (struct
  type t = int
  let compare = compare
end )

module Sset = Set.Make(String)

let rec list_compare l1 l2 = match l1, l2 with
  | [], [] -> 0
  | [], _ -> -1
  | _, [] -> 1
  | x1::tl1, x2::tl2 -> 
      let c = compare x1 x2 in
      if c = 0 then list_compare tl1 tl2 else c

let rec range a b = if a > b then [] else a :: (range (a + 1) b)

let rec replicate x = function
  | 0 -> []
  | n -> x :: (replicate x (n-1))

let rec prefix n = function
  | [] -> []
  | x::xs -> if n >= 1 then x :: (prefix (n-1) xs) else []

let rec remove_prefix n = function
  | [] -> []
  | x::xs -> if n >= 1 then remove_prefix (n-1) xs else x::xs

let rec mapi f = 
  let rec aux i = function
    | [] -> []
    | h::t -> (f i h)::(aux (i+1) t)
  in aux 0

let rec zip l l' = match l, l' with
  | [], _ -> []
  | _, [] -> []
  | x::xs, y::ys -> (x, y)::(zip xs ys)


let mips_id_separator = "."
let word_size = 4
