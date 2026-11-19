{
  config,
  lib,
  utils,
  pkgs,
  ...
}:

{
  options = {
    vris.zfs-credstore = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      devices = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };

      pool = lib.mkOption {
        type = lib.types.str;
        default = "rpool";
      };

      dataset = lib.mkOption {
        type = lib.types.str;
        default = "root";
      };

      zvol = lib.mkOption {
        type = lib.types.str;
        default = "credstore";
      };

      tpm2 = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      autologin = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config =
    let
      cfg = config.vris.zfs-credstore;
    in
    lib.mkIf cfg.enable {
      systemd.package = pkgs.systemd.overrideAttrs (
        oldAttrs:
        assert oldAttrs.version == "262";
        {
          version = "262-unstable-2026-11-17";

          patches = [
            (lib.elemAt oldAttrs.patches 0)
            ../files/0002-Change-usr-share-zoneinfo-to-etc-zoneinfo.patch
            ../files/0003-path-util.h-add-placeholder-for-DEFAULT_PATH_NORMAL.patch
            ../files/0004-core-don-t-taint-on-unmerged-usr.patch
          ];

          mesonFlags = oldAttrs.mesonFlags ++ [
            (lib.mesonEnable "rust" false)
          ];

          src = pkgs.fetchFromGitHub {
            owner = "systemd";
            repo = "systemd";
            rev = "6501c454c47ad39d241ad71ea7f69b4ee72e06fd";
            hash = "sha256-GR3NQcp/KxkvUo792Cq7aVknBRc0XxXLmi+qkQ1jSOE=";
          };
        }
      );

      security.pam.services.sddm-autologin = lib.mkIf cfg.autologin {
        rules.auth.sddm-autologin-user.order = lib.mkForce 13000;
        rules.auth.permit.order = lib.mkForce 13500;
        rules.auth.systemd-loadkey = {
          order = 10200;
          control = "optional";
          modulePath = "${config.systemd.package}/lib/security/pam_systemd_loadkey.so";
          settings.keyname = "tpm2-pin";
        };
        rules.auth.kwallet = {
          order = 12100;
          control = "optional";
          modulePath = "${pkgs.kdePackages.kwallet-pam}/lib/security/pam_kwallet5.so";
        };
      };

      systemd.services.display-manager = lib.mkIf cfg.autologin {
        serviceConfig.KeyringMode = "inherit";
      };

      services.displayManager.autoLogin = lib.mkIf cfg.autologin {
        enable = true;
        user = "leo60228";
      };

      # derived from https://discourse.nixos.org/t/import-zpool-before-luks-with-systemd-on-boot/65400/2
      boot.initrd = {
        systemd.services."zfs-import-${cfg.pool}".enable = false;

        systemd.services."import-${cfg.pool}-bare" =
          let
            devices = map (p: utils.escapeSystemdPath p + ".device") cfg.devices;
          in
          {
            after = [ "modprobe@zfs.service" ] ++ devices;
            requires = [ "modprobe@zfs.service" ];

            wants = [ "cryptsetup-pre.target" ] ++ devices;
            before = [ "cryptsetup-pre.target" ];

            unitConfig.DefaultDependencies = false;
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            path = [ config.boot.zfs.package ];
            enableStrictShellChecks = true;
            script =
              let
                # Check that the FSes we're about to mount actually come from
                # our encryptionroot. If not, they may be fraudulent.
                shouldCheckFS = fs: fs.fsType == "zfs" && utils.fsNeededForBoot fs;
                checkFS = fs: ''
                  encroot="$(zfs get -H -o value encryptionroot ${fs.device})"
                  if [ "$encroot" != ${cfg.pool}/${cfg.dataset} ]; then
                    echo ${fs.device} has invalid encryptionroot "$encroot" >&2
                    exit 1
                  else
                    echo ${fs.device} has valid encryptionroot "$encroot" >&2
                  fi
                '';
              in
              ''
                function cleanup() {
                  exit_code=$?
                  if [ "$exit_code" != 0 ]; then
                    zpool export ${cfg.pool}
                  fi
                }
                trap cleanup EXIT
                zpool import -N -d /dev/disk/by-id ${cfg.pool}

                # Check that the file systems we will mount have the right encryptionroot.
                ${lib.concatStringsSep "\n" (
                  lib.map checkFS (lib.filter shouldCheckFS config.system.build.fileSystems)
                )}
              '';
          };

        luks.devices.credstore = {
          device = "/dev/zvol/${cfg.pool}/${cfg.zvol}";
          crypttabExtraOpts = lib.ifEnable cfg.tpm2 [
            "tpm2-measure-pcr=yes"
            "tpm2-device=auto"
          ];
        };

        supportedFilesystems.ext4 = true;
        systemd.contents."/etc/fstab".text = ''
          /dev/mapper/credstore /etc/credstore ext4 defaults,x-systemd.after=systemd-cryptsetup@credstore.service 0 2
        '';
        systemd.targets.initrd-switch-root = {
          conflicts = [
            "etc-credstore.mount"
            "systemd-cryptsetup@credstore.service"
          ];
          after = [
            "etc-credstore.mount"
            "systemd-cryptsetup@credstore.service"
          ];
        };
        systemd.services.systemd-udevd.before = [ "systemd-cryptsetup@credstore.service" ];

        systemd.services."${cfg.pool}-load-key" = {
          requiredBy = [ "initrd.target" ];
          before = [
            "sysroot.mount"
            "initrd.target"
          ];
          requires = [ "import-${cfg.pool}-bare.service" ];
          after = [ "import-${cfg.pool}-bare.service" ];
          unitConfig.RequiresMountsFor = "/etc/credstore";
          unitConfig.DefaultDependencies = false;
          serviceConfig = {
            Type = "oneshot";
            ImportCredential = "zfs-sysroot.mount";
            RemainAfterExit = true;
            ExecStart = "${config.boot.zfs.package}/bin/zfs load-key -L file://\"\${CREDENTIALS_DIRECTORY}\"/zfs-sysroot.mount ${cfg.pool}/${cfg.dataset}";
          };
        };
      };
    };
}
