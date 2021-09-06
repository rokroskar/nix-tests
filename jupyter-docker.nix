with import <nixpkgs> { system = "x86_64-linux"; };
    let
        ubuntu = pkgs.dockerTools.pullImage {
        imageName = "ubuntu";
        finalImageTag = "focal";
        imageDigest = "sha256:9d6a8699fb5c9c39cf08a0871bd6219f0400981c570894cd8cbea30d3424a31f";
        sha256 = "1yv17hm2y82kdg4cypkvw3xi2hh22l1kkvvbqgmhf8wxvbs4bya1";
        };

        debian = pkgs.dockerTools.pullImage {
        imageName = "debian";
        finalImageTag = "stretch";
        imageDigest = "sha256:205cce0b204ae98be1723d2df0a188bd254ee79f949b51b35bde5dfa91320b72";
        sha256 = "171a54jdmchii39qbk86xbjbrzjng9cysaw4a2ams952kfs7vz0q";
        };

        jupyter = import (builtins.fetchGit {
        url = https://github.com/tweag/jupyterWith;
        rev = "";
        }) {};

        iPython = jupyter.kernels.iPythonWith {
        name = "python";
        packages = p: with p; [ numpy ];
        };

        jupyterEnvironment =
        jupyter.jupyterlabWith {
        kernels = [ iPython ];
        };

        my-python-packages = python-packages: with python-packages; [
            jupyterlab
        ];
        python-with-my-packages = pkgs.python39.withPackages my-python-packages;

        mach-nix = import (builtins.fetchGit {
            url = "https://github.com/DavHau/mach-nix";
            ref = "refs/tags/3.3.0";
        }) {
            python = "python39";
        };

        python-packages = mach-nix.mkPython {
            requirements = ''
            jupyterlab
        '';
        };
    in
    pkgs.dockerTools.buildLayeredImage {
        name = "jupyter";
        tag = "latest";
        created = "now";
        fromImage = debian;
        # runAsRoot = ''
        #     #!${stdenv.shell}
        #     export PATH=/bin:/usr/bin:/sbin:/usr/sbin:$PATH
        #     '';
        contents = [ python-packages pkgs.bashInteractive ];
        config = {
            Env = [
                "LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive"
                "LANG=en_US.UTF-8"
                "LANGUAGE=en_US:en"
                "LC_ALL=en_US.UTF-8"
            ];
            CMD = [ "/bin/jupyter-lab" "--ip=0.0.0.0" "--no-browser" "--allow-root" ];
            WorkingDir = "/data";
            ExposedPorts = {
                "8888" = {};
            };
            Volumes = {
                "/data" = {};
            };
        };
    }
