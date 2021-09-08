let
  pkgs = import <nixpkgs> { system = "x86_64-linux"; };
in with pkgs; with import ./renku.nix; {
  renku-docker = with pkgs; dockerTools.buildImage {
    name = "renku";
    tag = "latest";
    created = "now";
    contents = [ renku bashInteractive coreutils python39 ];
    runAsRoot = ''
      #!${pkgs.runtimeShell}
      ${shadowSetup}
      groupadd -r jovyan
      useradd -r -g jovyan jovyan
      mkdir /data
      chown jovyan:jovyan /data
    '';
    config = {
      # User = "jovyan";
      Env = [
          "LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive"
          "LANG=en_US.UTF-8"
          "LANGUAGE=en_US:en"
          "LC_ALL=en_US.UTF-8"
      ];
      ENTRYPOINT = [ "renku" ];
      CMD = [ ];
      WorkingDir = "/";
    };
  };
}
