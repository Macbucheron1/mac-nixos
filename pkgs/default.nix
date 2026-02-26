{ pkgs }:
rec {
  supabase-auth = pkgs.python3Packages.callPackage ./python3Packages.supabase-auth.nix {};
  supabase-functions = pkgs.python3Packages.callPackage ./python3Packages.supabase-functions.nix {};
  realtime = pkgs.python3Packages.callPackage ./python3Packages.realtime.nix {};
  storage3 = pkgs.python3Packages.callPackage ./python3Packages.storage3.nix { inherit pyiceberg; };
  postgrest = pkgs.python3Packages.callPackage ./python3Packages.postgrest.nix {};
  pyiceberg = pkgs.python3Packages.callPackage ./python3Packages.pyiceberg.nix {};
  supabase = pkgs.python3Packages.callPackage ./python3Packages.supabase.nix { inherit supabase-auth supabase-functions realtime storage3 postgrest; };
  exegol = pkgs.callPackage ./exegol.nix { inherit supabase; };
}

