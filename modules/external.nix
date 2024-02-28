{ lib, flakes, ... }:
{
  imports = [
    flakes.home-manager.nixosModules.home-manager
  ];
}
