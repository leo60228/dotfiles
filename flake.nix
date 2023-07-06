{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.home-manager = {
    url = github:nix-community/home-manager;
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
  inputs.mpdiscord = {
    url = github:leo60228/mpdiscord;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.deploy-rs.url = "github:serokell/deploy-rs";
  inputs.fizz-strat = {
    url = "github:BlaseballCrabs/fizz-strat";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, deploy-rs, ... } @ flakes: (rec {
    nixosConfigurations = nixpkgs.lib.mapAttrs (n: x: nixpkgs.lib.nixosSystem {
      system = (import (./hardware + "/${n}.nix")).system;
      modules = [ x ];
      specialArgs = {
        inherit flakes;
      };
    }) (import ./. null).systems;
    hydraJobs =
      let
        jobs = nixpkgs.lib.mapAttrs (n: x: {
          ${x.config.nixpkgs.system} = x.config.system.build.toplevel;
        }) nixosConfigurations;
      in
        jobs;
    deploy.nodes = nixpkgs.lib.genAttrs [ "leoservices" "digitaleo" "nucserv" "leoserv" "crabstodon" ] (x: {
      hostname = x;

      profiles.system = {
        user = "root";
        path = deploy-rs.lib.${nixosConfigurations.${x}.config.nixpkgs.system}.activate.nixos nixosConfigurations.${x};
      };
    });
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
    legacyPackages = (import flakes.nixpkgs {
      inherit system;
      overlays = map (e:
        let
          rawOverlay = import (./nixpkgs + ("/" + e));
          hasArgs = builtins.functionArgs rawOverlay != {};
          overlay = if hasArgs then rawOverlay flakes else rawOverlay;
        in overlay
      ) (builtins.attrNames (builtins.readDir ./nixpkgs));
    }).callPackages ./pkgs {};
    apps = nixpkgs.lib.mapAttrs (n: x: {
      type = "app";
      program = "${x}/bin/${n}";
    }) packages;
  })));
}
