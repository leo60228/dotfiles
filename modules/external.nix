{ lib, flakes, ... }:
{
  imports = [
    flakes.home-manager.nixosModules.home-manager
    flakes.kde2nix.nixosModules.plasma6
  ];
}
