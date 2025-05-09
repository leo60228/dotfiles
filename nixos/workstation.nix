# vi: set foldmethod=marker:

{
  config,
  flakes,
  lib,
  pkgs,
  ...
}:

{
  options = {
    vris.workstation = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.vris.workstation {
    assertions = [
      {
        assertion = config.vris.graphical;
        message = "workstations must be graphical";
      }
    ];

    # Packages {{{1
    hardware.enableAllFirmware = true;
    services.pcscd.enable = true;
    programs.java.enable = true;
    programs.bash.completion.enable = true;
    programs.nix-ld.enable = true;
    boot.supportedFilesystems = [
      "nfs"
      "ntfs"
    ];

    environment.systemPackages = [
      pkgs.androidenv.androidPkgs.platform-tools
      pkgs.openocd
      pkgs.OVMFFull
      config.virtualisation.libvirtd.qemu.package
      pkgs.steam
      pkgs.virt-manager
      pkgs.kdePackages.sddm-kcm
      pkgs.kdePackages.audiocd-kio
      pkgs.kdePackages.skanpage
      pkgs.kdePackages.isoimagewriter
      pkgs.kdePackages.krdc
      pkgs.kdePackages.neochat
      pkgs.kdePackages.konversation
      pkgs.kdePackages.discover
      pkgs.kdePackages.partitionmanager
      pkgs.kdePackages.kclock
      (flakes.rom-properties.packages.${pkgs.system}.rp_kde6.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [ ../files/rp_larger_icons.diff ];
      }))
    ];

    vris.firefox = lib.mkDefault pkgs.firefox;

    # Avahi {{{1
    services.avahi = {
      enable = true;
      allowPointToPoint = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        domain = true;
        addresses = true;
      };
    };

    # Printing {{{1
    services.printing = {
      enable = true;
      drivers = [
        pkgs.hplip
        pkgs.gutenprint
        pkgs.gutenprintBin
      ];
    };
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };

    # Configuration {{{1
    programs.fuse.userAllowOther = true;
    programs.command-not-found.dbPath =
      flakes.flake-programs-sqlite.packages.${pkgs.system}.programs-sqlite;

    # Debuggers {{{1
    services.udev.packages = [
      pkgs.android-udev-rules
      pkgs.platformio-core
      pkgs.openocd
    ];

    # KVM {{{1
    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu.ovmf.packages = [ pkgs.OVMFFull.fd ];
    };
    users.groups.libvirtd.members = [
      "root"
      "leo60228"
    ];
    systemd.services.libvirtd.path = with pkgs; [
      bash
      killall
      libvirt
      kmod
      swtpm
    ];

    # Docker {{{1
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
      extraOptions = "--experimental";
    };

    # Nix {{{1
    nix.distributedBuilds = true;
    nix.buildMachines = [
      {
        systems = [ "aarch64-linux" ];
        supportedFeatures = [
          "big-parallel"
          "benchmark"
        ];
        sshKey = "/home/leo60228/.ssh/id_ed25519";
        maxJobs = 100;
        hostName = "eu.nixbuild.net";
      }
    ];
    nix.settings.builders-use-substitutes = true;

    # Steam {{{1
    hardware.graphics.enable32Bit = true;
    services.pipewire.alsa.support32Bit = true;
    hardware.steam-hardware.enable = true;
    boot.blacklistedKernelModules = [ "hid-steam" ];

    # binfmt {{{1
    boot.binfmt = {
      emulatedSystems = [
        "armv7l-linux"
        "aarch64-linux"
      ];
      # TODO: https://nixpk.gs/pr-tracker.html?pr=402027
      #preferStaticEmulators = true;
      addEmulatedSystemsToNixSandbox = false;
    };

    nix.settings.extra-platforms = [
      "armv7l-linux"
    ] ++ lib.optional pkgs.stdenv.hostPlatform.isx86_64 "i686-linux";
    nix.settings.extra-sandbox-paths = [ "/run/binfmt" ];
    # }}}

    users.extraUsers.leo60228.extraGroups = [
      "scanner"
      "docker"
    ];
  };
}
