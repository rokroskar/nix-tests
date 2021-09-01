with import <nixpkgs> { system = "x86_64-linux"; };
    let ubuntu = pkgs.dockerTools.pullImage {
        imageName = "ubuntu";
        finalImageTag = "focal";
        imageDigest = "sha256:9d6a8699fb5c9c39cf08a0871bd6219f0400981c570894cd8cbea30d3424a31f";
        sha256 = "1yv17hm2y82kdg4cypkvw3xi2hh22l1kkvvbqgmhf8wxvbs4bya1";
    };
    in
    pkgs.dockerTools.buildImage {
        name = "jupyter";
        tag = "latest";
        created = "now";
        # fromImage = ubuntu;
        runAsRoot = ''
            #!${stdenv.shell}
            export PATH=/bin:/usr/bin:/sbin:/usr/sbin:$PATH
            '';
        contents = [ pkgs.python39Packages.jupyterlab python39Packages.pip bash ];
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
