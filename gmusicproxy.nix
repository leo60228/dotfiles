{pkgs}:
let depPkgs = with pkgs; [python27Packages.gmusicapi python27Packages.docutils python27Packages.eyeD3 python27Packages.netifaces python27Packages.pyxdg];
    deps = pkgs.lib.makeSearchPath "lib/python2.7/site-packages" depPkgs;
    repo = pkgs.fetchFromGitHub {
      owner = "diraimondo";
      repo = "gmusicproxy";
      rev = "9c6edd07ed174e076c82a409e250402a9c17afc6";
      sha256 = "1db99ah4nqns9gwa4xsv9ic42kns0jwpl6qdyx2v6390aiqlnhj5";
    };
in pkgs.writeShellScriptBin "gmusicproxy" "export PYTHONPATH=\"${deps}\"; ${repo}/GMusicProxy \"$@\""
