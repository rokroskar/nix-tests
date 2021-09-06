let
    pkgs = import <nixpkgs> { system = "x86_64-linux"; };

    debian = pkgs.dockerTools.pullImage {
        imageName = "debian";
        finalImageTag = "stretch";
        imageDigest = "sha256:205cce0b204ae98be1723d2df0a188bd254ee79f949b51b35bde5dfa91320b72";
        sha256 = "171a54jdmchii39qbk86xbjbrzjng9cysaw4a2ams952kfs7vz0q";
        };

    mach-nix = import (builtins.fetchGit {
        url = "https://github.com/DavHau/mach-nix";
        ref = "refs/tags/3.3.0";
    }) { inherit pkgs; };

    jupyter =
        mach-nix.mkPython {
        requirements = ''
            jupyterlab
        '';
        };
    renku = pkgs.callPackage ./renku-simple.nix {};
in
    pkgs.dockerTools.buildLayeredImage {
    name = "mach-nix";
    tag = "latest";
    fromImage = debian;
    created = "now";
    contents = [ jupyter renku pkgs.bashInteractive pkgs.git pkgs.git-lfs pkgs.nodejs ];
    config = {
        Env = [
            "LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive"
            "LANG=en_US.UTF-8"
            "LANGUAGE=en_US:en"
            "LC_ALL=en_US.UTF-8"
        ];
        CMD = [ "jupyter lab --ip=0.0.0.0 --allow-root" ];
        WorkingDir = "/data";
        Volumes = {
            "/data" = {};
        };
    };
}
