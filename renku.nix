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
  # mach-nix.buildPythonPackage {
  #   src = fetchFromGitHub {
  #       owner = "SwissDataScienceCenter";
  #       repo = "renku-python";
  #       rev = "548b81587d77f10433b24bbd277d052155c2792a";
  #       sha256 = "06jdgn70hj5bw7r7g91i8mva16j5pj4mvi39x4gwzldca2hh5za0";
  #       leaveDotGit = true;
  #       deepClone = true;
  #   };
  #   version = "0.16.0";
  #   requirements = ''
  #     renku==0.16.0
  #     setuptools_rust
  #     ruamel.yaml<=0.16.5,>=0.12.4
  #     cffi>=1.12
  #   '';

  #   propagatedBuildInputs.mod = pySelf: self: oldVal: oldVal ++ [ pySelf.yagup pySelf.cffi git git-lfs nodejs ];
  #   nativeBuildInputs = [ git ];
  #   GIT_PYTHON_GIT_EXECUTABLE = "${git}/bin/git";
  #   GIT_SSL_NO_VERIFY = "true";
  #   preBuild = "export HOME=$(mktemp -d)";
  # }
