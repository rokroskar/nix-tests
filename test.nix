{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

with pkgs;
    let
        renku = import /renku.nix { pkgs=pkgs; };

    in dockerTools.buildImage {
        name = "renku/custom-env";
        fromImage = baseImage;
            
        contents = [
            bash
            coreutils
            renku
        ];
        runAsRoot = ''
           #!${pkgs.runtimeShell}
           mkdir -p /data
         '';
        extraCommands = "mkdir -p tmp";
    }
