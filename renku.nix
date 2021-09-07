let
  pkgs = import <nixpkgs> { system = "x86_64-linux"; };
  mach-nix = import (builtins.fetchGit {
     url = "https://github.com/DavHau/mach-nix/";
     ref = "master";
   }) {
      inherit pkgs;
      pypiDataRev = "977d3dbd460a24930880d59102730a0a4519d5fb";
      pypiDataSha256 = "0mkvgkbvb94dy6p50xf9cw900psk6j2syp70hgxxynsnbjfcgw2w";
    };
in with pkgs;
  mach-nix.mkPython {
    requirements = ''
      renku==0.16.0
      setuptools_rust
      ruamel.yaml<=0.16.5,>=0.12.4
      yagup>=0.1.1
      cffi
    '';
    _.renku.nativeBuildInputs.add = with mach-nix.nixpkgs; [ git git-lfs nodejs ];
    _.cryptography.propagatedBuildInputs.mod = pySelf: self: oldVal: oldVal ++ [ pySelf.cffi ];
    _.renku.propagatedBuildInputs.mod = pySelf: self: oldVal: with mach-nix.nixpkgs; oldVal ++ [
      git
      git-lfs
      nodejs
      pySelf.yagup
    ];
  }
