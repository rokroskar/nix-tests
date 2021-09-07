let
    pkgs = import <nixpkgs> { system = "x86_64-linux"; };
    jupyterBase = pkgs.dockerTools.pullImage {
        imageName = "bitnami/jupyter-base-notebook";

        finalImageTag = "latest";
        imageDigest = "sha256:ac96c04763508c2bd429a3f3cc94ef77c0ec354305347bacedecd9208f00dfa9";
        sha256 = "1a3b3qd5jwrxn50x9f4qns7dml4kv7dsk02skzhpdgxhbq1yvfsi";
    };
    renku = import ./renku.nix;
in with pkgs;
    dockerTools.buildLayeredImage {
        name = "jupyter-base";
        tag = "latest";
        created = "now";
        fromImage = jupyterBase;
        contents = [ renku ];
        config = {
            Env = [
                "LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive"
                "LANG=en_US.UTF-8"
                "LANGUAGE=en_US:en"
                "LC_ALL=en_US.UTF-8"
            ];
            CMD = [ "jupyter-lab" "--ip=0.0.0.0" "--no-browser" "--allow-root" ];
            WorkingDir = "/data";
            ExposedPorts = {
                "8888" = {};
            };
            Volumes = {
                "/data" = {};
            };
        };
    }
