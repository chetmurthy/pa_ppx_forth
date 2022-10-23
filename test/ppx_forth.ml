open OUnit2

let simple_tests = "simple tests" >::: [
      "simple" >:: (fun ctxt -> ())
    ]
;;

(* Run the tests in test suite *)
let _ =
if not !Sys.interactive then
  run_test_tt_main ("all_tests" >::: [
        simple_tests
    ])
;;
