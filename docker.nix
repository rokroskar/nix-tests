with import <nixpkgs> { system = "x86_64-linux"; };
    let
        # NOTE: deeplabcut build all packages ourselves solution
        # deeplabcut = import ./dlc.nix { pkgs = pkgs; python = python37; };
        # manylinux1 = [ pkgs.pythonManylinuxPackages.manylinux1 ];
        # overrides = deeplabcut.overrides manylinux1 pkgs.autoPatchelfHook;
        # my_python = python37.override {packageOverrides = overrides;};
        # pythonEnv = my_python.withPackages (ps: deeplabcut.select_pkgs ps);

        # NOTE: deeplabcut build directly with Nix dependencies
        #deeplabcut = import ./deeplabcut.nix { pkgs = pkgs;  };
        #pythonEnv = python37.withPackages (ps: [deeplabcut]);

        # NOTE: no deeplabcut
        pythonEnv = python37;

    in dockerTools.buildImage {
        name = "renku/r_gnuplot_env";
        contents = [
            R
            rPackages.dplyr
            gnuplot
            pythonEnv
            bash
            coreutils
            gnugrep
            findutils
            jupyter
        ];
        extraCommands = "mkdir -p tmp";
    }
