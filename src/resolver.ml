(* RESOLVER.ML

   Résolution générale du problème de la résolution de noms
*)

module type Element = sig
  type t
  val compare : t -> t -> int
end


module Make (Elt : Element) = struct
  type el = Elt.t

  module Emap = Map.Make(Elt)
  module Eset = Set.Make(Elt)

  (* Une représentation sous forme de graphe de la relation d'ordre *)
  type t = Eset.t Emap.t

  let empty = Emap.empty

  let mem = Emap.mem


  let add leq_fun e graph = 

    if mem e graph then graph
    else
     
        let link x y g = Emap.add x 
          (Eset.add y (try Emap.find x g with Not_found -> Eset.empty)) g in

        Emap.fold (fun e' _ g' ->
          if leq_fun e e' then link e e' g' 
          else if leq_fun e' e then link e' e g'
          else g' )

          graph (Emap.add e Eset.empty graph)


  exception Conflict of (el list)
  exception No_match

  let resolve leq_fun e graph =

    let applicants_arity = Emap.fold (fun e' neighs acc ->
      if leq_fun e e' then (e', Eset.cardinal neighs)::acc else acc )
      graph [] in
       
    let n_applicants = List.length applicants_arity in
    let min_elt = List.map fst (List.filter (fun (_, arity) -> 
      arity >= n_applicants - 1) applicants_arity) in

    if n_applicants = 0 then raise No_match
    else match min_elt with
      | [x] -> x
      
      (* Ne devrait pas arriver si [leq] est un ordre *)
      | x1::x2::_ -> assert false
      | [] -> (


        (* Une ambiguité a été trouvée : on établit
           la liste de tous les éléments minimaux afin de signaler un
           conflit. Ce code est lent mais ne devra être executé qu'une
           seule fois en cas d'erreur *)

        let applicants_set = 
          List.fold_right (Eset.add) 
            (List.map fst applicants_arity) Eset.empty in
        
        let min_elts = Eset.fold (fun x acc ->
          Eset.diff acc (Emap.find x graph) )
          applicants_set applicants_set in

        let min_elts_list = Eset.fold (fun x y -> x :: y) min_elts [] in

        raise (Conflict min_elts_list)
      )



end



