open OUnit2
open Day2

let tests = "Test suite for invalid id" >::: [
    "Valid id" >:: (fun _ -> assert_equal (is_valid_id 112) true);
    "Small numbers" >:: (fun _ -> assert_equal (is_valid_id 11) false);
    "Split one digit" >:: (fun _ -> assert_equal (get_digits 1) [1]);
    "Split two digits" >:: (fun _ -> assert_equal (get_digits 12) [1; 2]);
    "Split negative two digits" >:: (fun _ -> assert_equal (get_digits (-12)) [1; 2]);
    "Get a range between ids" >:: (fun _ -> assert_equal (get_range 1 5) [1; 2; 3; 4; 5;]);

    "Invalid range" >:: (fun _ -> assert_equal (invalid_ids_in_range 11 22) [11; 22]);
    "Invalid range" >:: (fun _ -> assert_equal (invalid_ids_in_range 95 115) [99]);
    "Invalid range" >:: (fun _ -> assert_equal (invalid_ids_in_range 998 1012) [1010]);
    "Invalid range" >:: (fun _ -> assert_equal (invalid_ids_in_range 1188511880 1188511890) [1188511885]);
    "Invalid range" >:: (fun _ -> assert_equal (invalid_ids_in_range 222220 222224) [222222]);
    "Invalid range" >:: (fun _ -> assert_equal (invalid_ids_in_range 1698522 1698528) []);
    "Invalid range" >:: (fun _ -> assert_equal (invalid_ids_in_range 446443 446449) [446446]);
    "Invalid range" >:: (fun _ -> assert_equal (invalid_ids_in_range 38593856 38593862) [38593859]);

    (* PART 2 *)
    "Generate sequences" >:: (fun _ -> assert_equal (generate_sequences 12) [[1]]);
    "Generate sequences" >:: (fun _ -> assert_equal (generate_sequences 123456) [[1]; [1; 2;]; [1; 2; 3]]);

    "Sequence repeats" >:: (fun _ -> assert_equal false @@ sequence_repeats [9] [9; 9; 8]);
    "Sequence repeats" >:: (fun _ -> assert_equal false @@ sequence_repeats [2; 1] [2; 1; 2; 1; 2; 1; 2; 1; 1; 8]);

    "Sequence repeats" >:: (fun _ -> assert_equal true @@ sequence_repeats [1] [1; 1]);
    "Sequence repeats" >:: (fun _ -> assert_equal true @@ sequence_repeats [1; 2] [1; 2; 1; 2]);
    "Sequence repeats" >:: (fun _ -> assert_equal true @@ sequence_repeats [9] [9; 9; 9]);
    "Sequence repeats" >:: (fun _ -> assert_equal false @@ sequence_repeats [2; 1; 2; 1;] [2; 1; 2; 1; 2; 1; 2; 1; 1; 8]);

    "Invalid id (2) 11" >:: (fun _ -> assert_equal false @@ is_valid_id_2 11);
    "Invalid id (2) 123" >:: (fun _ -> assert_equal true @@ is_valid_id_2 123);
    "Invalid id (2) 2121212118" >:: (fun _ -> assert_equal true @@ is_valid_id_2 2121212118);
    "Invalid id (2) 2121212119" >:: (fun _ -> assert_equal true @@ is_valid_id_2 2121212119);

    "Invalid range part 2 (1)" >:: (fun _ -> assert_equal (invalid_ids_in_range_2 11 22) [11; 22]);
    "Invalid range part 2 (2)" >:: (fun _ -> assert_equal (invalid_ids_in_range_2 95 115) [99; 111]);
    "Invalid range part 2 (3)" >:: (fun _ -> assert_equal (invalid_ids_in_range_2 998 1012) [999; 1010]);
    "Invalid range part 2 (4)" >:: (fun _ -> assert_equal (invalid_ids_in_range_2 1188511880 1188511890) [1188511885]);
    "Invalid range part 2 (5)" >:: (fun _ -> assert_equal (invalid_ids_in_range_2 222220 222224) [222222]);
    "Invalid range part 2 (6)" >:: (fun _ -> assert_equal (invalid_ids_in_range_2 1698522 1698528) []);
    "Invalid range part 2 (7)" >:: (fun _ -> assert_equal (invalid_ids_in_range_2 446443 446449) [446446]);
    "Invalid range part 2 (8)" >:: (fun _ -> assert_equal (invalid_ids_in_range_2 38593856 38593862) [38593859]);
    "Invalid range part 2 (9)" >:: (fun _ -> assert_equal (invalid_ids_in_range_2 565653 565659) [565656]);
    "Invalid range part 2 (10)" >:: (fun _ -> assert_equal (invalid_ids_in_range_2 824824821 824824827) [824824824]);
    "Invalid range part 2 (11)" >:: (fun _ -> assert_equal [2121212121] @@ invalid_ids_in_range_2 2121212118 2121212124);
]

let _ = run_test_tt_main tests
