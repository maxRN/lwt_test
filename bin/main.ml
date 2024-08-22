let httpaf_connection_handler sock_addr y =
  let _ = sock_addr in
  let _ = y in
  Lwt.return (Printf.eprintf "got request\n%!")

let x =
  (* Look up the low-level address corresponding to the interface. Hopefully,
     this is a local interface. *)
  let%lwt listen_address =
    let%lwt addresses = Lwt_unix.getaddrinfo "127.0.0.1" "8888" [] in
    match addresses with
    | [] -> failwith "shouldn't happen"
    | address :: _ -> Lwt.return Lwt_unix.(address.ai_addr)
  in

  (* Bring up the HTTP server. Wait for the server to actually get started.
     Then, wait for the ~stop promise. If the ~stop promise ever resolves, stop
     the server. *)
  let%lwt server =
    Lwt_io.establish_server_with_client_socket listen_address
      httpaf_connection_handler
  in
  let never = fst (Lwt.wait ()) in
  let stop = never in
  let%lwt () = stop in
  Lwt_io.shutdown_server server

let () = Lwt_main.run x
