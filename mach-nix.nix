{ system ? builtins.currentSystem }:
let
    pkgs = import <nixpkgs> { inherit system; };
in with pkgs;
    import (builtins.fetchGit {
     url = "https://github.com/uwmisl/mach-nix";
     ref = "master";
   }) {
      inherit pkgs;
      pypiDataRev = "977d3dbd460a24930880d59102730a0a4519d5fb";
      pypiDataSha256 = "0mkvgkbvb94dy6p50xf9cw900psk6j2syp70hgxxynsnbjfcgw2w";
    }
