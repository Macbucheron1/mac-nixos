{ pkgs }:
rec {
  supabaseAuth = pkgs.python3Packages.callPackage ./python3Packages.supabase-auth.nix {};
  supabaseFunctions = pkgs.python3Packages.callPackage ./python3Packages.supabase-functions.nix {};
  exegol = pkgs.callPackage ./exegol.nix { inherit supabaseFunctions supabaseAuth; };
}

