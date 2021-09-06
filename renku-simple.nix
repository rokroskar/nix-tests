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
            ruamel.yaml==0.16.5"
        '';
    };

    cwl-upgrader = import ./cwl-upgrader/cwl-upgrader.nix;


in  with pkgs;
    python39.pkgs.buildPythonApplication {
    pname = "renku";
    version = "0.16.0";

    src = fetchFromGitHub {
        owner = "SwissDataScienceCenter";
        repo = "renku-python";
        rev = "3ab3ac1285d9d9fcdfa0bebf81e1357969b54939";
        sha256 = "1kfmb6zvrip8g0n2vx7mlnim37kyycv84ay532misvmywvmw9qjs";
        leaveDotGit = true;
    };
    propagatedBuildInputs = [ git git-lfs nodejs ruamel cwl-upgrader ];
    buildInputs = [ git ];
    GIT_PYTHON_GIT_EXECUTABLE = "${git}/bin/git";
    GIT_SSL_NO_VERIFY = "true";
}

# in  with pkgs;
    # mach-nix.buildPythonPackage {
    # src = fetchFromGitHub {
    #     owner = "SwissDataScienceCenter";
    #     repo = "renku-python";
    #     rev = "3ab3ac1285d9d9fcdfa0bebf81e1357969b54939";
    #     sha256 = "127m1kn7qwh0wpkns3n5ijvr32ln49w5mvamk8f96v1bmpvcm11m";
    #     leaveDotGit = true;
    # };
    # version = "0.16.0";
    # requirementsExtra = ''
    #     setuptools_rust
    # '';
    # propagatedBuildInputs = [ git git-lfs nodejs ruamel ];
    # buildInputs = [ git ];
    # GIT_PYTHON_GIT_EXECUTABLE = "${git}/bin/git";
    # GIT_SSL_NO_VERIFY = "true";
    # providers = {
    #     _default = "wheel,sdist,nixpkgs";
    # };

    # preBuild = ''
    #     pip uninstall typing
    # '';
