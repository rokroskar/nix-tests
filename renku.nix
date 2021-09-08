{ system ? builtins.currentSystem }:
let
  pkgs = import <nixpkgs> { inherit system; };
  mach-nix = pkgs.callPackage ./mach-nix.nix { inherit system; };
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
