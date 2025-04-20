{
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  systemd.services.amazon-init.enable = lib.mkForce false;

  systemd.services.NetworkManager-wait-online.enable = false;

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];

  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";

  deployment.tags = [ "servers" ];
}
