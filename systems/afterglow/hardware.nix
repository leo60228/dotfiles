{
  config,
  lib,
  pkgs,
  flakes,
  ...
}:
{
  imports = [
    (import "${flakes.mobile-nixos}/lib/configuration.nix" { device = "lenovo-krane"; })
  ];

  networking.firewall.checkReversePath = lib.mkForce false;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/69a72ebc-ca68-41a1-873e-9da9b7ec5796";
    fsType = "ext4";
  };

  boot.growPartition = false;

  boot.initrd.luks.devices."lvm".device = "/dev/disk/by-uuid/8590eb97-c03f-4689-847d-da39c62f1111";

  zramSwap.enable = true;

  # https://gitlab.collabora.com/mediatek/aiot/linux/-/merge_requests/9
  environment.sessionVariables.PAN_MESA_DEBUG = "noafbc";
}
