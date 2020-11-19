{
  nixos = { config, lib, pkgs, ... }: {
    imports = [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix> ];
    boot.loader.grub.device = "/dev/vda";
    fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };

    # This file was populated at runtime with the networking
    # details gathered from the active system.
    networking = {
      nameservers = [
        "67.207.67.3"
        "67.207.67.2"
      ];
      defaultGateway = "104.131.64.1";
      defaultGateway6 = "2604:a880:800:10::1";
      interfaces = {
        eth0 = {
          ipv4.addresses = [
            { address="104.131.74.33"; prefixLength=18; }
            { address="10.17.0.5"; prefixLength=16; }
          ];
          ipv6.addresses = [
            { address="fe80::d41c:23ff:feaa:812c"; prefixLength=64; }
            { address="2604:a880:800:10::156:6001"; prefixLength=64; }
          ];
        };
      };
    };
    services.udev.extraRules = ''
      ATTR{address}=="d6:1c:23:aa:81:2c", NAME="eth0"
    '';

    zramSwap.enable = true;

    swapDevices = [ {
      device = "/var/swapfile";
      size = 4096;
    } ];
  };

  nixops = {
    deployment.targetHost = "104.131.74.33";
  };

  system = "x86_64-linux";
}
