module Make (S : sig end) =
struct

  let c = ref 0 
  let reset () = c := 0
  let get () = incr c; !c

end
