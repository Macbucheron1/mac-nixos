{ nsearch, ... }:
[
  (import ./toto.nix { } )
  (import ./nsearch.nix { inherit nsearch; } )
]
