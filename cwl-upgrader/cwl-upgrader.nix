let
    pkgs = import <nixpkgs> { system = "x86_64-linux"; };

    mach-nix = import (builtins.fetchGit {
        url = "https://github.com/DavHau/mach-nix/";
        ref = "master";
        }) {
            inherit pkgs;
            pypiDataRev = "977d3dbd460a24930880d59102730a0a4519d5fb";
            pypiDataSha256 = "0mkvgkbvb94dy6p50xf9cw900psk6j2syp70hgxxynsnbjfcgw2w";
        };
    ruamel = mach-nix.mkPython {
        requirements = ''
            ruamel.yaml<0.16.5"
            schema-salad
        '';
    };

in  with pkgs;
    python39.pkgs.buildPythonPackage {
    pname = "cwl-upgrader";
    version = "1.12";

    src = fetchFromGitHub {
        owner = "common-workflow-language";
        repo = "cwl-upgrader";
        rev = "e3f995270cd6c52e8e2e1ad0b02a6c92d7333bea";
        sha256 = "1hhsbz0326dwrjpvxf654vqg4id6402fbvgpp5bkw1d2l2x9sr83";
        leaveDotGit = true;
    };
    doCheck = false;
    patches = [ ./cwl-upgrader-typing.patch ];
    propagatedBuildInputs = [ ruamel ];
}
