let nixpkgs = import <nixpkgs> {};
    depPkgs = with nixpkgs; [python27Packages.gmusicapi python27Packages.docutils python27Packages.eyeD3 python27Packages.netifaces python27Packages.pyxdg];
    depStrings = map (e: "\"${e}\"") depPkgs;
    deps = builtins.concatStringsSep " " depStrings;
    repo = nixpkgs.fetchFromGitHub {
      owner = "diraimondo";
      repo = "gmusicproxy";
      rev = "9c6edd07ed174e076c82a409e250402a9c17afc6";
      sha256 = "1db99ah4nqns9gwa4xsv9ic42kns0jwpl6qdyx2v6390aiqlnhj5";
    };
in nixpkgs.writeShellScriptBin "gmusicproxy" "${nixpkgs.nix}/bin/nix-shell -p ${deps} --run ${repo}/GMusicProxy"
