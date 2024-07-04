let
  lib = import ../lib;
in
lib.makeComponent "anbox" (
  {
    config,
    cfg,
    pkgs,
    lib,
    ...
  }:
  with lib;
  {
    opts = { };

    config = {
      assertions = singleton {
        assertion = versionAtLeast (getVersion config.boot.kernelPackages.kernel) "4.18";
        message = "Anbox needs user namespace support to work properly";
      };

      environment.systemPackages = [ pkgs.anbox ];

      services.udev.extraRules = ''
        KERNEL=="ashmem", NAME="%k", MODE="0666"
        KERNEL=="binder*", NAME="%k", MODE="0666"
      '';

      virtualisation.lxc.enable = true;
      networking.bridges.anbox0.interfaces = [ ];
      networking.interfaces.anbox0.ipv4.addresses = [
        {
          address = "192.168.250.1";
          prefixLength = 24;
        }
      ];

      networking.nat = {
        enable = true;
        internalInterfaces = [ "anbox0" ];
      };

      systemd.services.anbox-container-manager =
        let
          anboxloc = "/var/lib/anbox";
        in
        {
          description = "Anbox Container Management Daemon";

          environment.XDG_RUNTIME_DIR = "${anboxloc}";

          wantedBy = [ "multi-user.target" ];
          after = [ "systemd-udev-settle.service" ];
          preStart =
            let
              initsh = pkgs.writeText "nixos-init" (''
                #!/system/bin/sh
                setprop nixos.version ${config.system.nixos.version}
                # we don't have radio
                setprop ro.radio.noril yes
                stop ril-daemon
                # speed up boot
                setprop debug.sf.nobootanimation 1
              '');
              initshloc = "${anboxloc}/rootfs-overlay/system/etc/init.goldfish.sh";
            in
            ''
              mkdir -p ${anboxloc}
              mkdir -p $(dirname ${initshloc})
              [ -f ${initshloc} ] && rm ${initshloc}
              cp ${initsh} ${initshloc}
              chown 100000:100000 ${initshloc}
              chmod +x ${initshloc}
            '';

          serviceConfig = {
            ExecStart = ''
              ${pkgs.anbox}/bin/anbox container-manager \
                --data-path=${anboxloc} \
                --android-image=${pkgs.anbox.image} \
                --container-network-address=192.168.250.2 \
                --container-network-gateway=192.168.250.1 \
                --container-network-dns-servers=1.1.1.1 \
                --use-rootfs-overlay \
                --privileged
            '';
          };
        };

      systemd.mounts = [
        {
          type = "binder";
          what = "binder";
          where = "/dev/binderfs";
          wantedBy = [ "multi-user.target" ];
          before = [ "anbox-container-manager.service" ];
        }
      ];
    };
  }
)
