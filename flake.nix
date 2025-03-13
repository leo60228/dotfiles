{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nur.url = "github:nix-community/NUR";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.naersk = {
    url = "github:nmattia/naersk";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.poetry2nix-src = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.mpdiscord = {
    url = "github:leo60228/mpdiscord";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.rust-overlay.follows = "rust-overlay";
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
    url = "https://git.lix.systems/lix-project/hydra/archive/main.tar.gz";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.lix.follows = "lix";
  };
  inputs.lix = {
    url = "git+https://git@git.lix.systems/lix-project/lix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.lix-module = {
    url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    inputs.lix.follows = "lix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.colmena = {
    url = "github:zhaofengli/colmena";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.flake-programs-sqlite = {
    url = "github:wamserma/flake-programs-sqlite";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.treefmt-nix = {
    url = "github:numtide/treefmt-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.pre-commit-hooks = {
    url = "github:cachix/git-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.rom-properties = {
    url = "github:Whovian9369/rom-properties-nix-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  inputs.lanzaboote = {
    url = "github:nix-community/lanzaboote/v0.4.2";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";
  inputs.pnpm2nix = {
    url = "github:leo60228/pnpm2nix-nzbr";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.moonlight = {
    url = "github:moonlight-mod/moonlight";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.pnpm2nix.follows = "pnpm2nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      colmena,
      flake-utils,
      treefmt-nix,
      pre-commit-hooks,
      ...
    }@flakes:
    (
      {
        colmena =
          let
            dotfiles = import ./. null;
            inherit (dotfiles) systems;
            meta = {
              nixpkgs = nixpkgs.legacyPackages.x86_64-linux;

              nodeNixpkgs = nixpkgs.lib.mapAttrs (
                n: x:
                let
                  hardware = import (./hardware + "/${n}.nix");
                  inherit (hardware) system;
                in
                nixpkgs.legacyPackages.${system}
              ) systems;

              specialArgs.flakes = flakes;

              allowApplyAll = false;
            };
            defaults =
              { ... }:
              {
                config.nixpkgs.flake.source = nixpkgs.outPath;
              };
          in
          systems // { inherit meta defaults; };

        nixosConfigurations =
          nixpkgs.lib.mapAttrs
            (
              n: x:
              nixpkgs.lib.nixosSystem {
                system = self.outputs.colmena.meta.nodeNixpkgs.${n}.system;
                modules = [
                  x
                  colmena.nixosModules.deploymentOptions
                ];
                inherit (self.outputs.colmena.meta) specialArgs;
              }
            )
            (
              builtins.removeAttrs self.outputs.colmena [
                "meta"
                "defaults"
              ]
            );

        hydraJobs =
          let
            jobs = nixpkgs.lib.mapAttrs (n: x: {
              ${x.config.nixpkgs.system} = x.config.system.build.toplevel;
            }) self.outputs.nixosConfigurations;
          in
          jobs;
      }
      // (flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          bootstrap =
            let
              inherit (pkgs)
                makeWrapper
                stdenvNoCC
                lib
                lix
                nixos-rebuild
                ;
            in
            stdenvNoCC.mkDerivation {
              name = "bootstrap";
              nativeBuildInputs = [ makeWrapper ];
              src = ./bootstrap.sh;
              dontUnpack = true;
              installPhase = ''
                mkdir -p $out/bin
                cp $src $out/bin/bootstrap
              '';
              fixupPhase = ''
                wrapProgram $out/bin/bootstrap --prefix PATH : ${
                  lib.makeBinPath [
                    lix
                    nixos-rebuild
                  ]
                }
              '';
            };
          packages = {
            inherit (pkgs) nixos-rebuild;
            inherit bootstrap;
          };
          treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks.treefmt = {
              enable = true;
              package = treefmtEval.config.build.wrapper;
            };
          };
        in
        {
          inherit packages;
          legacyPackages =
            (import flakes.nixpkgs {
              inherit system;
              overlays = map (
                e:
                let
                  rawOverlay = import (./nixpkgs + ("/" + e));
                  hasArgs = builtins.functionArgs rawOverlay != { };
                  overlay = if hasArgs then rawOverlay flakes else rawOverlay;
                in
                overlay
              ) (builtins.attrNames (builtins.readDir ./nixpkgs));
            }).callPackages
              ./pkgs
              { };
          apps = nixpkgs.lib.mapAttrs (n: x: {
            type = "app";
            program = "${x}/bin/${n}";
          }) packages;
          formatter = treefmtEval.config.build.wrapper;
          checks = {
            inherit pre-commit-check;
            formatting = treefmtEval.config.build.check self;
          };
          devShells.default = pkgs.mkShell {
            inherit (pre-commit-check) shellHook;
            buildInputs = pre-commit-check.enabledPackages;
          };
        }
      ))
    );
}
