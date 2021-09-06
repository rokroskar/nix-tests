let
  pkgs = import <nixpkgs> { system = "x86_64-linux"; };
  mach-nix = import (builtins.fetchGit {
     url = "https://github.com/DavHau/mach-nix/";
     ref = "master";
   }) { inherit pkgs; };
in with pkgs;
  mach-nix.mkPython {
    requirements = ''
    renku==0.16.0
    setuptools_rust
    ruamel.yaml<=0.16.5,>=0.12.4
    '';
    _.renku.buildInputs.add = [ pkgs.git pkgs.git-lfs pkgs.nodejs ];
    providers = {
      # The default for all packages which are not specified explicitly
      _default = "wheel,sdist,nixpkgs";

      # Explicit settings per package
      cryptography = "nixpkgs,wheel,sdist";
      cffi = "nixpkgs,wheel,sdist";
    };
  }
