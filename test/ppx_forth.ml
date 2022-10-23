open OUnit2

module Forth : sig
    type 's t
    type empty = unit
    type empty_t = unit t
 
    val start : unit -> unit t
    val num : int -> 'a t -> ([`number] * 'a) t
    val plus : ([`number] * ([`number] * 'a)) t -> ([`number] * 'a) t
    val dot : ([`number] * 'a) t -> 'a t
end = struct
    type 's t = unit
    type empty = unit
    type empty_t = unit t
 
    let start () = ()
    let num x s = s
    let plus s = s
    let dot s = s
end

open Forth

let simple_tests = "simple tests" >::: [
      "simple" >:: (fun ctxt -> ())
    ; "0" >:: (fun ctxt ->
      ignore([%forth]))
    ; "1" >:: (fun ctxt ->
      ignore([%forth 1 2 plus dot;]))
    ]
;;

(* Run the tests in test suite *)
let _ =
if not !Sys.interactive then
  run_test_tt_main ("all_tests" >::: [
        simple_tests
    ])
;;
