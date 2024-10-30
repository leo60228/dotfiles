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

      services.displayManager.sddm.settings = {
        General = {
          Numlock = "none";
          GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192";
        };

        Theme = {
          CursorSize = 48;
          CursorTheme = "breeze_cursors";
          Font = "Sans Serif,10,-1,5,50,0,0,0,0,0";
        };

        X11 = {
          ServerArguments = "-dpi 192";
        };
      };
      services.xserver.displayManager.setupCommands = ''
        echo 'Xcursor.theme: breeze_cursors' | ${pkgs.xorg.xrdb}/bin/xrdb -nocpp -merge
      '';

      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };

      environment.systemPackages = [ pkgs.sbctl ];

      networking.networkmanager.wifi.backend = "iwd";

      deployment.tags = [ "workstation" ];
      deployment.allowLocalDeployment = true;
    };

  nixops = {
    deployment.targetHost = "penumbra";
  };

  system = "x86_64-linux";
}
