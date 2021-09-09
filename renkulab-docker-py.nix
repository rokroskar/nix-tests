let
    system = "x86_64-linux";
    pkgs = import <nixpkgs> { inherit system; };
    debian = pkgs.dockerTools.pullImage {
        imageName = "debian";
        finalImageTag = "stretch";
        imageDigest = "sha256:205cce0b204ae98be1723d2df0a188bd254ee79f949b51b35bde5dfa91320b72";
        sha256 = "171a54jdmchii39qbk86xbjbrzjng9cysaw4a2ams952kfs7vz0q";
    };
    jupyterBase = pkgs.dockerTools.pullImage {
        imageName = "bitnami/jupyter-base-notebook";
        finalImageTag = "latest";
        imageDigest = "sha256:ac96c04763508c2bd429a3f3cc94ef77c0ec354305347bacedecd9208f00dfa9";
        sha256 = "1a3b3qd5jwrxn50x9f4qns7dml4kv7dsk02skzhpdgxhbq1yvfsi";
    };

    # get the renku environment
    renku-env = pkgs.callPackage ./renku-env.nix { inherit system; };

    # make the base image with user setup
    base-image = with pkgs; dockerTools.buildImage {
        name = "base-image";
        tag = "latest";
        fromImage = debian;
        runAsRoot = ''
            #!${runtimeShell}
            ${dockerTools.shadowSetup}
            groupadd -r jovyan -g 1000
            useradd -s /bin/bash -m -r -u 1000 -g jovyan jovyan
            mkdir /data
            chown jovyan:jovyan /data
        '';
    };
in
    with pkgs;
    dockerTools.buildLayeredImage {
        name = "jupyter-base";
        tag = "latest";
        fromImage = base-image;
        contents = [ renku-env git git-lfs nodejs jq bashInteractive curl graphviz ];
        config = {
            User = "jovyan";
            Env = [
                "LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive"
                "LANG=en_US.UTF-8"
                "LANGUAGE=en_US:en"
                "LC_ALL=C.UTF-8"
                "RENKU_DISABLE_VERSION_CHECK=1"
                "color_prompt=yes"
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
