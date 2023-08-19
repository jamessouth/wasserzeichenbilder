open Core

let gravity =
  let open Command.Param in
  let grav dir =
    let name = sprintf "-%s" dir in
    let doc = sprintf " %s gravity" dir in
    flag ~full_flag_required:() name no_arg ~doc
    |> map ~f:(function false -> None | true -> Some dir)
  in

  choose_one
    [
      grav "NorthWest";
      grav "North";
      grav "NorthEast";
      grav "West";
      grav "Center";
      grav "East";
      grav "SouthWest";
      grav "South";
      grav "SouthEast";
    ]
    ~if_nothing_chosen: (Default_to "Center")

let () =
  Command_unix.run ~version:"1.0" ~build_info:"RWO"
    (Command.basic ~summary:"fib clock"
       ~readme:(fun () -> "aosihaiu")
       (let%map_open.Command ah = gravity in
        fun () -> Stdlib.print_endline ah))
