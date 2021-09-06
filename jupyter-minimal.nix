let
  pkgs = import <nixpkgs> { system = "x86_64-linux"; };
  jupyter = import (builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "";
  }) {inherit pkgs;};

  jupyterEnvironment = jupyter.jupyterlabWith {};
in
    pkgs.dockerTools.buildLayeredImage {
      name = "jupyter";
      tag = "latest";
      created = "now";
      contents = [ jupyterEnvironment ];
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
