{ system ? "x86_64-linux" }:
let
  pkgs = import <nixpkgs> { system = system; };
   mach-nix = import (builtins.fetchGit {
     url = "https://github.com/DavHau/mach-nix/";
     ref = "refs/tags/3.3.0";
   }) { inherit pkgs; };
  renku = mach-nix.mkPython {
    requirements =  ''
      renku
    '';
    };
in
  mach-nix.nixpkgs.mkShell{
    buildInputs = [ renku pkgs.git ];
  }
