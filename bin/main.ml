let httpaf_connection_handler sock_addr y =
  let _ = sock_addr in
  let _ = y in
  let%lwt () = Lwt_io.printl "got request!" in
  Lwt_io.eprintl "got request on stderr!"

let x =
  let%lwt listen_address =
    let%lwt addresses = Lwt_unix.getaddrinfo "127.0.0.1" "7654" [] in
    match addresses with
    | [] -> failwith "shouldn't happen"
    | address :: _ -> Lwt.return Lwt_unix.(address.ai_addr)
  in
  let%lwt server =
    Lwt_io.establish_server_with_client_socket listen_address
      httpaf_connection_handler
  in
  let never = fst (Lwt.wait ()) in
  let stop = never in
  let%lwt () = stop in
  Lwt_io.shutdown_server server

let () = Lwt_main.run x
