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

    requirements = mach-nix.mkPython {
        requirements = ''
            setuptools_rust
            ruamel.yaml<=0.16.5,>=0.12.4
        '';
    };

    cwl-upgrader = import ./cwl-upgrader/cwl-upgrader.nix;

in with pkgs;
    python39.pkgs.buildPythonApplication {
    pname = "renku";
    version = "0.16.0";

    src = fetchFromGitHub {
        owner = "SwissDataScienceCenter";
        repo = "renku-python";
        rev = "548b81587d77f10433b24bbd277d052155c2792a";
        sha256 = "06jdgn70hj5bw7r7g91i8mva16j5pj4mvi39x4gwzldca2hh5za0";
        leaveDotGit = true;
        deepClone = true;
    };
    propagatedBuildInputs = [ git git-lfs nodejs requirements cwl-upgrader ];
    nativeBuildInputs = [ git ];
    GIT_PYTHON_GIT_EXECUTABLE = "${git}/bin/git";
    GIT_SSL_NO_VERIFY = "true";
    preBuild = "export HOME=$(mktemp -d)";
}

# in  with pkgs;
#     mach-nix.buildPythonApplication {
#     src = fetchFromGitHub {
#         owner = "SwissDataScienceCenter";
#         repo = "renku-python";
#         rev = "3ab3ac1285d9d9fcdfa0bebf81e1357969b54939";
#         sha256 = "0zaz1672xichbz717j6w016va7sdipfmrdif02am5gfi5amlnd2x";
#         leaveDotGit = true;
#     };
#     version = "0.16.0";
#     requirementsExtra = ''
#         setuptools_rust
#     '';
#     propagatedBuildInputs = [ git git-lfs nodejs ruamel cwl-upgrader ];
#     nativeBuildInputs = [ git cwl-upgrader ];
#     GIT_PYTHON_GIT_EXECUTABLE = "${git}/bin/git";
#     GIT_SSL_NO_VERIFY = "true";
#     providers = {
#         _default = "wheel,sdist,nixpkgs";
#     };
# }
