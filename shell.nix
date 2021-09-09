{ system ? builtins.currentSystem }:
let
    pkgs = import <nixpkgs> { inherit system; };
    renku-env = pkgs.callPackage ./renku-env.nix { inherit system; };
in with pkgs; pkgs.mkShell {
    buildInputs = [ renku-env git git-lfs nodejs jq bashInteractive curl graphviz ];
}
