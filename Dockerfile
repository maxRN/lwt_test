FROM ocaml/opam@sha256:c900eb55237d14dd57bc10c2f7f9fb09d8b236bcc9572c9f283c9bddfa096fd3 AS build

# Install system dependencies
RUN sudo apk add --update libev-dev openssl-dev gmp-dev pcre-dev libev-dev pkgconf postgresql14-dev sqlite-dev

# Pull the latest OPAM repository updates
RUN cd ~/opam-repository && git pull origin master && opam update
WORKDIR /dream
COPY dune-project .
RUN opam install dune lwt lwt_ppx
COPY .  .
RUN ls -lah
RUN opam exec -- dune build

ENTRYPOINT ["opam", "exec", "--", "dune", "exec", "lwt_test"]
