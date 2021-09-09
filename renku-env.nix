{ system ? builtins.currentSystem install_vscode ? false }:
let
    pkgs = import <nixpkgs> { inherit system; };
    mach-nix = pkgs.callPackage ./mach-nix.nix { inherit system; };
    renku = pkgs.callPackage ./renku.nix { inherit system; };
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
        packagesExtra = [ renku "https://github.com/betatim/vscode-binder/tarball/master" ];
        _.gitpython.propagatedBuildInputs.mod = pySelf: self: oldVal: oldVal ++ [ pySelf.typing-extensions ];
        _.vscode-binder.propagatedBuildInputs.mod = pySelf: self: oldVal: oldVal ++ [ code-server ];
    }
