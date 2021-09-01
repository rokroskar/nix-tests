{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

with pkgs;
let
   mach-nix = import (builtins.fetchGit {
     url = "https://github.com/DavHau/mach-nix/";
     ref = "refs/tags/2.2.2";
   });

in mach-nix.mkPython rec {
  python = python39;
  requirements =  ''
    renku
  '';
}
