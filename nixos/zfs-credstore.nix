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
    };
  };

  config =
    let
      cfg = config.vris.zfs-credstore;
    in
    lib.mkIf cfg.enable {
      # derived from https://discourse.nixos.org/t/import-zpool-before-luks-with-systemd-on-boot/65400/2
      assertions = [
        {
          assertion = config.boot.initrd.systemd.enable;
          message = "systemd stage-1 required for zfs-credstore";
        }
      ];

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
