{ system ? builtins.currentSystem }:
let
    pkgs = import <nixpkgs> { inherit system; };
    mach-nix = pkgs.callPackage ./mach-nix.nix { inherit system; };
in with pkgs;
    mach-nix.mkPython {
        requirements = ''
            jupyter-server-proxy
            jupyterlab-git
            jupyterlab-system-monitor
            jupyterlab
            typing-extensions>=3.7.4.3
            pip
            setuptools
        '';
        _.gitpython.propagatedBuildInputs.mod = pySelf: self: oldVal: oldVal ++ [ pySelf.typing-extensions ];
    }
