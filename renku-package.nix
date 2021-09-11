{ system ? builtins.currentSystem }:
let
    pkgs = import <nixpkgs> { inherit system; };
    mach-nix = pkgs.callPackage ./mach-nix.nix { inherit system; };
in with pkgs;
    mach-nix.buildPythonApplication {
    pname = "renku";
    version = "0.16.0";

    src = fetchFromGitHub {
        owner = "SwissDataScienceCenter";
        repo = "renku-python";
        rev = "548b81587d77f10433b24bbd277d052155c2792a";
        sha256 = "06jdgn70hj5bw7r7g91i8mva16j5pj4mvi39x4gwzldca2hh5za0";
        leaveDotGit = true;
        deepClone = true;
    };
    requirementsExtra = ''
        setuptools_rust
        ruamel.yaml<=0.16.5,>=0.12.4
        yagup>=0.1.1
        cffi
    '';
    _.cryptography.propagatedBuildInputs.mod = pySelf: self: oldVal: oldVal ++ [ pySelf.cffi ];
    nativeBuildInputs = [ git git-lfs nodejs ];
    GIT_SSL_NO_VERIFY = "true";
    preBuild = "export HOME=$(mktemp -d)";
}
