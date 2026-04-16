{
  modulesPath,
  ...
}:
{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];

  boot.supportedFilesystems = [ "zfs" ];

  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" = {
    device = "rpool/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3099-F3B1";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  networking = {
    dhcpcd.enable = false;
    nameservers = [
      "45.90.28.142"
      "45.90.30.142"
      "2a07:a8c0::c4:a844"
      "2a07:a8c1::c4:a844"
    ];
    defaultGateway = "86.48.28.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };
    interfaces = {
      ens18 = {
        ipv4.addresses = [
          {
            address = "86.48.30.173";
            prefixLength = 22;
          }
        ];
        ipv6.addresses = [
          {
            address = "2605:a144:2323:7818::1";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  boot.initrd.secrets."/var/lib/root-key" = null;

  deployment.tags = [ "servers" ];
}
