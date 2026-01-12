(* common utils *)

let format_list l =
    Printf.sprintf "[%s]" @@ List.fold_left (fun acc v -> Printf.sprintf "%s %d;" acc v) "" l
;;

let list_sub lst start len =
  lst |> List.filteri (fun i _ -> i >= start && i < start + len)
;;

let rec get_digits_impl num acc =
    if num == 0 then acc
    else get_digits_impl (num / 10) ((num mod 10) :: acc)
;;

let get_digits num =
    get_digits_impl (abs num) []
;;

let get_range first last =
    List.init (last - first + 1) (fun v -> v + first)
;;

(* PART 1 *)

let is_valid_id id =
    let digits = get_digits id in
    let is_odd = ((List.length digits) mod 2) != 0 in
    let mid = (List.length digits) / 2 in
    let first_half = list_sub digits 0 mid in
    let second_half = list_sub digits mid mid in
    is_odd || not (List.equal (fun a b -> a = b) first_half second_half)
;;

let invalid_ids_in_range first last =
    let range = get_range first last in
    range |> List.filter (fun v -> not (is_valid_id v))
;;

(*
Part 2:

Only partial sequences are required
- Not just any repeating digits
- Needs to be a repeating pattern throughout the whole id

Will need to form the sequences
123456 has the following sequences
[ 1
; 12
; 123
]

Only really need to go to halfway through the whole id since it needs to repeat
*)

let generate_sequences id =
    let digits = get_digits id in
    let mid = (List.length digits) / 2 in
    let range = get_range 1 mid in
    List.fold_left (fun acc v -> list_sub digits 0 v :: acc) [] range |> List.rev
;;

let sequence_repeats seq digits =
    let seq_len = List.length seq in
    let count = List.length digits / seq_len in
    let rem = List.length digits mod seq_len in
    rem = 0 && (
        get_range 1 (count - 1)
        |> List.map (fun idx ->
            list_sub digits (seq_len * idx) seq_len
            |> List.equal Int.equal seq
        )
        |> List.fold_left (fun acc v -> acc && v) true
    )
;;

let is_valid_id_2 id =
    let digits = get_digits id in
    let sequences = generate_sequences id in
    sequences
    |> List.map (fun seq -> sequence_repeats seq digits)
    |> List.fold_left (fun acc repeats -> acc && (not repeats)) true
;;

let invalid_ids_in_range_2 first last =
    let range = get_range first last in
    range |> List.filter (fun v -> not (is_valid_id_2 v))
;;

