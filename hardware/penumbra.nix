{
  nixos =
    {
      config,
      lib,
      modulesPath,
      pkgs,
      flakes,
      ...
    }:
    {
      imports = [
        "${modulesPath}/installer/scan/not-detected.nix"
        flakes.nixos-hardware.nixosModules.framework-13-7040-amd
        flakes.lanzaboote.nixosModules.lanzaboote
      ];

      config = {
        boot.kernelPackages = pkgs.linuxPackages_latest;
        boot.initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
          "thunderbolt"
          "usb_storage"
          "sd_mod"
        ];
        boot.initrd.kernelModules = [ "dm-snapshot" ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        boot.extraModprobeConfig = ''
          options cfg80211 ieee80211_regdom="US"
          options amdgpu dcdebugmask=0x10
        '';

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/41691e95-8ec6-45a9-8f0e-6a3c72fd6c70";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/5EBE-7AB7";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        swapDevices = [ { device = "/dev/disk/by-uuid/f735a083-e7e4-46ca-a0b0-73f280f3d8ad"; } ];

        boot.initrd.luks.devices."lvm".device = "/dev/disk/by-uuid/32bfc36e-2640-4110-bc58-b93564acaafa";

        services.power-profiles-daemon.enable = true;

        console.earlySetup = true;
        console.packages = [ pkgs.terminus_font ];
        console.font = "ter-128n";

        services.displayManager.sddm.wayland.enable = true;

        security.pam.services.polkit-1.fprintAuth = true;

        boot.loader.systemd-boot.enable = lib.mkForce false;

        boot.lanzaboote = {
          enable = true;
          pkiBundle = "/etc/secureboot";
        };

        environment.systemPackages = [ pkgs.sbctl ];

        networking.networkmanager.wifi.backend = "iwd";

        hardware.framework.laptop13.audioEnhancement = {
          enable = true;
          rawDeviceName = "alsa_output.pci-0000_c1_00.6.HiFi__Speaker__sink";
        };

        environment.sessionVariables.ALSA_CONFIG_UCM2 =
          let
            alsa-ucm-conf = pkgs.fetchFromGitHub {
              owner = "leo60228";
              repo = "alsa-ucm-conf";
              rev = "616f1eb856149047e642d58ea2a03bbdc92631f0";
              sha256 = "sha256-Vg52YjL9lvWWTrahA2+r/BtrTX0F6s2XNqzBl3xWtw0=";
            };
          in
          "${alsa-ucm-conf}/ucm2";

        deployment.tags = [ "workstation" ];
        deployment.allowLocalDeployment = true;
      };

      options.security.pam.services = lib.mkOption {
        type =
          with lib.types;
          attrsOf (
            submodule (
              { ... }:
              {
                config.fprintAuth = lib.mkDefault false;
              }
            )
          );
      };
    };

  nixops = {
    deployment.targetHost = "penumbra";
  };

  system = "x86_64-linux";
}
