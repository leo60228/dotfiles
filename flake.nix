{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
  inputs.home-manager = {
    url = github:nix-community/home-manager/release-21.11;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nixpkgs-mozilla = {
    url = github:mozilla/nixpkgs-mozilla;
    flake = false;
  };
  inputs.nur.url = github:nix-community/NUR;
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.naersk = {
    url = github:nmattia/naersk;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.poetry2nix-src.url = github:nix-community/poetry2nix;
  inputs.vfio-isolate = {
    url = github:spheenik/vfio-isolate;
    flake = false;
  };
  inputs.mpdiscord = {
    url = github:leo60228/mpdiscord;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.data_expunged = {
    url = github:BlaseballCrabs/data_expunged;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.hauntbot = {
    url = github:BlaseballCrabs/hauntbot;
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
      nix = flakes.nixpkgs.legacyPackages.${system}.nixUnstable;
      nixos-rebuild = flakes.nixpkgs.legacyPackages.${system}.nixos-rebuild.override {
        inherit nix;
      };
      bootstrap = let
        inherit (nixpkgs.legacyPackages.${system}) makeWrapper stdenvNoCC lib;
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
        wrapProgram $out/bin/bootstrap --prefix PATH : ${lib.makeBinPath [ nix nixos-rebuild ]}
        '';
      };
    };
    apps = nixpkgs.lib.mapAttrs (n: x: {
      type = "app";
      program = "${x}/bin/${n}";
    }) packages;
  })));
}
