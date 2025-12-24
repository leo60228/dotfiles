# vi: set foldmethod=marker:
{
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "18.03";

  vris.workstation = true;
  vris.graphical = true;
  vris.prometheus = true;
  vris.apcupsd = {
    enable = true;
    timeout = 300;
    minutes = 15;
    batteryLevel = 50;
  };

  # Networking {{{1
  networking.firewall.allowedTCPPorts = (lib.range 3000 3010) ++ [
    34567
    34568
    22000
    8010
    6600
    9999
    111
    2049
    4000
    4001
    4002
    20048
    3306
    8888
  ];
  networking.firewall.allowedUDPPorts = [
    4010
    8000
    8001
    34567
    34568
    21027
    6600
    111
    2049
    4000
    4001
    4002
    20048
  ];

  services.tailscale.useRoutingFeatures = "both";

  # Hydra {{{1
  services.hydra-dev = {
    enable = true;
    package = pkgs.hydra;
    hydraURL = "https://hydra.capybara-pirate.ts.net";
    port = 9999;
    notificationSender = "hydra@60228.dev";
    minimumDiskFree = 30;
    minimumDiskFreeEvaluator = 2;
    useSubstitutes = true;
    buildMachinesFiles = [
      (pkgs.writeText "machines" ''
        eu.nixbuild.net aarch64-linux /var/lib/hydra/id_ed25519 100 1 big-parallel,benchmark -
        localhost i686-linux,x86_64-linux /var/lib/hydra/id_ed25519 24 2 kvm,nixos-test,big-parallel,benchmark -
      '')
    ];
    extraConfig = ''
      Include /var/lib/hydra/secrets.conf

      evaluator_workers = 8
    '';
  };
  systemd.services.hydra-queue-runner.wants = [ "network-online.target" ];

  services.postgresql.package = pkgs.postgresql_16;
  services.postgresql.settings.max_connections = 200;

  # Kodi {{{1
  services.nfs.server = {
    enable = true;
    exports = ''
      /srv/nfs *(ro,sync,all_squash,crossmnt,anonuid=1000,anongid=100,insecure)
    '';
    statdPort = 4000;
    lockdPort = 4001;
    mountdPort = 4002;
  };

  fileSystems."/srv/nfs/Music" = {
    device = "/home/leo60228/Music";
    options = [ "bind" ];
  };

  fileSystems."/srv/nfs/Videos" = {
    device = "/home/leo60228/Videos";
    options = [ "bind" ];
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    initialScript = pkgs.writeText "mysql_init" ''
      CREATE USER 'kodi' IDENTIFIED BY 'kodi';
      GRANT ALL ON *.* TO 'kodi';
    '';
    settings.mysqld.bind-address = "0.0.0.0";
  };

  # zrepl {{{1
  services.zrepl = {
    enable = true;
    settings = {
      jobs = [
        {
          type = "sink";
          name = "sink";

          serve = {
            type = "tcp";
            listen = "100.70.195.127:8888";
            listen_freebind = true;
            clients."100.105.49.45" = "penumbra";
          };

          root_fs = "rpool/zrepl/sink";
          recv.placeholder.encryption = "off";
        }
      ];
    };
  };
  # }}}
}
