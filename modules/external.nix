{ lib, flakes, ... }:
{
  imports = [
    flakes.home-manager.nixosModules.home-manager
    "${flakes.hydra}/nixos-modules/hydra.nix"
  ];

  nixpkgs.overlays = [ flakes.hydra.overlays.default ];
}
