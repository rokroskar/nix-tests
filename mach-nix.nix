{ system ? builtins.currentSystem }:
let
    pkgs = import <nixpkgs> { inherit system; };
in with pkgs;
    import (builtins.fetchGit {
     url = "https://github.com/uwmisl/mach-nix";
     ref = "master";
   }) {
      inherit pkgs;
      pypiDataRev = "5c6e5ecbc5a60fb9c43dc77be8e0eb8ac89f4fee";
      pypiDataSha256 = "0gnq6r92bmnhqjykx3jff7lvg7wbpayd0wvb0drra8r8dvmr5b2d";
    }
