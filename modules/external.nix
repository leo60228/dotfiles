{ lib, flakes, ... }:
{
  imports = [
    flakes.home-manager.nixosModules.home-manager
    "${flakes.hydra}/nixos-modules/hydra.nix"
    flakes.lix-module.nixosModules.default
  ];

  nixpkgs.overlays = [ flakes.hydra.overlays.default ];
}
