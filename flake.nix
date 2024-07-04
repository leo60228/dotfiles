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
  inputs.poetry2nix-src = {
    url = github:nix-community/poetry2nix;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.mpdiscord = {
    url = github:leo60228/mpdiscord;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.fizz-strat = {
    url = "github:BlaseballCrabs/fizz-strat";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nixos-apple-silicon = {
    url = "github:tpwrules/nixos-apple-silicon";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.upd8r = {
    url = "github:leo60228/upd8r";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.hydra = {
    url = "git+https://git@git.lix.systems/lix-project/hydra";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.nix.follows = "lix";
  };
  inputs.lix = {
    url = "git+https://git@git.lix.systems/lix-project/lix";
    flake = false;
  };
  inputs.lix-module = {
    url = "git+https://git.lix.systems/lix-project/nixos-module";
    inputs.lix.follows = "lix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.colmena = {
    url = "github:zhaofengli/colmena";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, colmena, flake-utils, ... } @ flakes: ({
    colmena =
      let
        dotfiles = import ./. null;
        inherit (dotfiles) systems;
        meta = {
          nixpkgs = nixpkgs.legacyPackages.x86_64-linux;

          nodeNixpkgs = nixpkgs.lib.mapAttrs (n: x:
            let
              hardware = import (./hardware + "/${n}.nix");
              inherit (hardware) system;
            in
              nixpkgs.legacyPackages.${system}) systems;

          specialArgs.flakes = flakes;

          allowApplyAll = false;
        };
      in
        systems // { inherit meta; };

    nixosConfigurations = nixpkgs.lib.mapAttrs (n: x: nixpkgs.lib.nixosSystem {
      system = self.outputs.colmena.meta.nodeNixpkgs.${n}.system;
      modules = [ x colmena.nixosModules.deploymentOptions ];
      inherit (self.outputs.colmena.meta) specialArgs;
    }) (builtins.removeAttrs self.outputs.colmena ["meta" "defaults"]);

    hydraJobs =
      let
        jobs = nixpkgs.lib.mapAttrs (n: x: {
          ${x.config.nixpkgs.system} = x.config.system.build.toplevel;
        }) self.outputs.nixosConfigurations;
      in
        jobs;
  } // (flake-utils.lib.eachDefaultSystem (system: rec {
    packages = rec {
      nixos-rebuild = flakes.nixpkgs.legacyPackages.${system}.nixos-rebuild;
      bootstrap = let
        inherit (nixpkgs.legacyPackages.${system}) makeWrapper stdenvNoCC lib nix;
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
