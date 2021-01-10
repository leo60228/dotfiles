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
  inputs.nix = {
    url = github:NixOS/nix;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.naersk = {
    url = github:nmattia/naersk;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ flakes: (rec {
    nixosConfigurations = nixpkgs.lib.mapAttrs (n: x: nixpkgs.lib.nixosSystem {
      system = (import (./hardware + "/${n}.nix")).system;
      modules = [ x ];
      specialArgs = {
        inherit flakes;
      };
    }) (import ./. null).systems;
  } // (flake-utils.lib.eachDefaultSystem (system: rec {
    packages = rec {
      nixos-rebuild =
        let
          baseSystem = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./modules/flakes.nix
              {
                nixpkgs.overlays = [ (import ./nixpkgs/nix.nix flakes) ];
              }
            ];
          };
          nixos-rebuild = baseSystem.config.system.build.nixos-rebuild;
        in nixos-rebuild;
      nix = flakes.nix.defaultPackage.${system};
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
    };
    apps = nixpkgs.lib.mapAttrs (n: x: {
      type = "app";
      program = "${x}/bin/${n}";
    }) packages;
  })));
}
