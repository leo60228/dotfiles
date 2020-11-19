{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.09;
  inputs.home-manager = {
    url = github:nix-community/home-manager/release-20.09;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nixpkgs-mozilla = {
    url = github:mozilla/nixpkgs-mozilla;
    flake = false;
  };
  inputs.nur.url = github:nix-community/NUR;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, flake-utils, ... } @ flakes: rec {
    nixosConfigurations = nixpkgs.lib.mapAttrs (n: x: nixpkgs.lib.nixosSystem {
      system = (import (./hardware + "/${n}.nix")).system;
      modules = [ x ];
      specialArgs = {
        inherit flakes;
      };
    }) (import ./. null).systems;
    packages = flake-utils.lib.eachDefaultSystem (system: rec {
      nixos-rebuild =
        let
          baseSystem = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [ ./modules/flakes.nix ];
          };
          nixos-rebuild = baseSystem.config.system.build.nixos-rebuild;
        in nixos-rebuild;
      nix = nixpkgs.legacyPackages.${system}.nixFlakes;
      bootstrap = let
        inherit (nixpkgs.legacyPackages.${system}) makeWrapper stdenvNoCC;
      in stdenvNoCC.mkDerivation {
        name = "bootstrap";
        nativeBuildInputs = [ makeWrapper ];
        src = ./bootstrap.sh;
        dontUnpack = true;
        installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/bootstrap
        '';
        fixupPhase = ''
        wrapProgram $out/bin/bootstrap --prefix PATH : ${nixpkgs.lib.makeBinPath [ nix nixos-rebuild ]}
        '';
      };
    });
  };
}
