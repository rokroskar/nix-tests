let
  system = "x86_64-linux";
  pkgs = import <nixpkgs> { system = "x86_64-linux"; };
  renku = pkgs.callPackage ./renku.nix { inherit system; };

  # set up a minimal base image with user modification
  base-image = with pkgs; dockerTools.buildImage {
        name = "base-image";
        tag = "latest";
        runAsRoot = ''
            #!${runtimeShell}
            ${dockerTools.shadowSetup}
            groupadd -r shuhitsu -g 1000
            useradd -s /bin/bash -m -r -u 1000 -g shuhitsu shuhitsu
            mkdir /data
            chown shuhitsu:shuhitsu /data
        '';
    };

in with pkgs; dockerTools.buildLayeredImage {
  name = "renku";
  tag = "latest";
  fromImage = base-image;
  contents = [ renku bashInteractive coreutils ];
  config = {
    User = "shuhitsu";
    Env = [
        "LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive"
        "LANG=en_US.UTF-8"
        "LANGUAGE=en_US:en"
        "LC_ALL=en_US.UTF-8"
    ];
    ENTRYPOINT = [ "renku" ];
    CMD = [ ];
    WorkingDir = "/data";
  };
}
