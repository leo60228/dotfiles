{
  config,
  lib,
  pkgs,
  flakes,
  ...
}:
{
  imports = [
    (import "${flakes.mobile-nixos}/lib/configuration.nix" { device = "lenovo-homestar"; })
  ];

  networking.firewall.checkReversePath = lib.mkForce false;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c85a48fa-bd42-4e20-993b-5ed87e8548f3";
    fsType = "ext4";
  };

  boot.growPartition = false;

  boot.initrd.luks.devices."lvm".device = "/dev/disk/by-uuid/6e45bd62-0f61-471b-8e08-cf0545b4f606";

  zramSwap.enable = true;

  hardware.firmware = [ pkgs.chromeos-sc7180-unredistributable-firmware ];

  hardware.sensor.iio.enable = true;
}
