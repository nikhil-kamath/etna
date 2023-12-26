open Scanf

let rec lookup l k =
  match l with
  | [] -> None
  | (k', v) :: l' -> if k = k' then Some v else lookup l' k

let extract_number line =
  try sscanf line "%s : %f" (fun stat num -> [ (stat, num) ])
  with _ -> []

let read_lines filename : string list =
  let ic = open_in filename in
  let try_read () = try Some (input_line ic) with End_of_file -> None in
  let rec loop acc =
    match try_read () with
    | Some s -> loop (s :: acc)
    | None ->
        close_in ic;
        List.rev acc
  in
  loop []

(* Gets the target statistic from a fuzzer_stats file generated by afl-fuzz *)
let parse filename statistic =
  lookup (List.concat_map extract_number (read_lines filename)) statistic