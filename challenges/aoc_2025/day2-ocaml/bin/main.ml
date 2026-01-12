let input_file = "day2.txt"

type range =
    { start: int;
      finish: int;
    }
;;

let parse_instructions contents = 
    String.split_on_char ',' contents
        |> List.map (fun v -> String.trim v |> String.split_on_char '-')
        |> List.filter (fun v -> List.length v == 2)
        |> List.map (
            fun v -> {
                start = int_of_string @@ List.nth v 0;
                finish = int_of_string @@ List.nth v 1;
            }
        )
;;

let () = 
    let ic = open_in input_file in
    let contents = In_channel.input_all ic in
    let instructions = parse_instructions contents in
    let invalid_ones = instructions
        |> List.map (fun r -> Day2.invalid_ids_in_range_2 r.start r.finish)
        |> List.flatten
    in
    let sum = invalid_ones |> List.fold_left (fun acc v -> acc + v) 0 in
    Printf.printf "%d" sum
    (*List.iter (fun r -> Printf.printf "{%d, %d}\n" r.start r.finish) instructions*)
;;
