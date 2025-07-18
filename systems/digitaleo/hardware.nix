{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];
  boot.loader.grub.device = "/dev/vda";
  fileSystems."/" = {
    device = "/dev/disk/by-label/cloudimg-rootfs";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/58A1-A55A";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "100.100.100.100"
      "79.110.170.43"
    ];
    search = [ "60228.dev.beta.tailscale.net" ];
    defaultGateway = "68.183.112.1";
    defaultGateway6 = "2604:a880:800:10::1";
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "68.183.115.15";
            prefixLength = 20;
          }
          {
            address = "165.227.252.37";
            prefixLength = 24;
          }
          {
            address = "10.10.0.6";
            prefixLength = 16;
          }
        ];
        ipv6.addresses = [
          {
            address = "2604:a880:400:d0::1d2a:b001";
            prefixLength = 64;
          }
          {
            address = "fe80::58a4:c9ff:fe09:ef0b";
            prefixLength = 64;
          }
        ];
        ipv4.routes = [
          {
            address = "68.183.112.1";
            prefixLength = 32;
          }
        ];
        ipv6.routes = [
          {
            address = "2604:a880:400:d0::1";
            prefixLength = 32;
          }
        ];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="5a:a4:c9:09:ef:0b", NAME="eth0"
    ATTR{address}=="7a:2d:0b:fe:36:27", NAME="eth1"
  '';

  zramSwap.enable = true;

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];

  deployment.tags = [ "servers" ];
}
