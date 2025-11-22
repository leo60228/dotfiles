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
    environment.sessionVariables.LD_LIBRARY_PATH = [ (lib.makeLibraryPath [ pkgs.icu ]) ];

    environment.systemPackages = [
      pkgs.androidenv.androidPkgs.platform-tools
      pkgs.openocd
      pkgs.OVMFFull
      config.virtualisation.libvirtd.qemu.package
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
      (flakes.rom-properties.packages.${pkgs.stdenv.hostPlatform.system}.rp_kde6.overrideAttrs
        (oldAttrs: {
          patches = oldAttrs.patches ++ [ ../files/rp_larger_icons.diff ];
        })
      )
      pkgs.syncthingtray
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
    programs.command-not-found = {
      enable = true;
      dbPath = flakes.flake-programs-sqlite.packages.${pkgs.stdenv.hostPlatform.system}.programs-sqlite;
    };

    # Debuggers {{{1
    services.udev.packages = [
      pkgs.platformio-core
      pkgs.openocd
    ];

    services.nixseparatedebuginfod2.enable = true;

    # KVM {{{1
    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu.swtpm.enable = true;
    };
    users.groups.libvirtd.members = [
      "root"
      "leo60228"
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
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          LD_PRELOAD = "${pkgs.mangohud}/lib/mangohud/libMangoHud_shim.so";
        };
      };
    };
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
    ]
    ++ lib.optional pkgs.stdenv.hostPlatform.isx86_64 "i686-linux";
    nix.settings.extra-sandbox-paths = [ "/run/binfmt" ];

    # Syncthing {{{1
    services.syncthing = {
      enable = true;
      user = "leo60228";
      group = "users";
      dataDir = "/home/leo60228";
      configDir = "/home/leo60228/.config/syncthing";
      openDefaultPorts = true;
    };

    # Networking {{{1
    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ]; # tailscale has its own firewall, and default-deny on tailscale0 causes breakage
      checkReversePath = "loose";

      # allow SSDP responses
      allowedUDPPorts = [ 1900 ];
      extraPackages = [ pkgs.conntrack-tools ];
      extraCommands = ''
        nfct add helper ssdp inet udp
        nfct add helper ssdp inet6 udp
        ip46tables -t raw -I OUTPUT -p udp --dport 1900 -j CT --helper ssdp
        ip46tables -t raw -I PREROUTING -p udp --dport 1900 -j CT --helper ssdp
      '';
      extraStopCommands = ''
        ip46tables -t raw -D OUTPUT -p udp --dport 1900 -j CT --helper ssdp
        ip46tables -t raw -D PREROUTING -p udp --dport 1900 -j CT --helper ssdp
      '';
    };

    environment.etc."conntrackd/conntrackd.conf".text = ''
      Helper {
        Type ssdp inet udp {
          QueueNum 5
          QueueLen 10240
          Policy ssdp {
            ExpectMax 1
            ExpectTimeout 300
          }
        }
        Type ssdp inet6 udp {
          QueueNum 5
          QueueLen 10240
          Policy ssdp {
            ExpectMax 1
            ExpectTimeout 300
          }
        }
      }

      General {
        Systemd yes
        Syslog yes
        LockFile /var/lock/conntrack.lock
        UNIX {
          Path /var/run/conntrackd.ctl
        }
      }
    '';

    systemd.services.conntrackd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      restartTriggers = [ config.environment.etc."conntrackd/conntrackd.conf".source ];
      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.conntrack-tools}/bin/conntrackd";
      };
    };

    # fwupd {{{1
    services.fwupd.enable = true;
    services.packagekit.enable = true;
    services.packagekit.settings.Daemon.DefaultBackend = "test_succeed";
    environment.etc."fwupd/remotes.d/lvfs-testing.conf" = lib.mkForce {
      text = ''
        [fwupd Remote]
        Enabled=true
        Title=Linux Vendor Firmware Service (testing)
        MetadataURI=https://cdn.fwupd.org/downloads/firmware-testing.xml.gz
        ReportURI=https://fwupd.org/lvfs/firmware/report
        OrderBefore=lvfs,fwupd
        AutomaticReports=false
        ApprovalRequired=false
      '';
    };
    # }}}

    users.extraUsers.leo60228.extraGroups = [
      "scanner"
      "docker"
    ];
  };
}
