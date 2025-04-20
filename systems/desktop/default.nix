# vi: set foldmethod=marker:
{
  config,
  pkgs,
  lib,
  ...
}:

with import ../../components;
rec {
  imports = [ ./hardware.nix ];

  components = home { deviceScaleFactor = 2; };

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

  boot.binfmt.emulatedSystems = [ "armv7l-linux" ];

  # Networking {{{
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
  # }}}

  # Hydra {{{
  services.hydra-dev = {
    enable = true;
    package = pkgs.hydra;
    hydraURL = "http://desktop:9999";
    port = 9999;
    notificationSender = "hydra@60228.dev";
    minimumDiskFree = 30;
    minimumDiskFreeEvaluator = 2;
    useSubstitutes = true;
    buildMachinesFiles = [
      (pkgs.writeText "machines" ''
        eu.nixbuild.net aarch64-linux /var/lib/hydra/id_ed25519 100 1 big-parallel,benchmark - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSVBJUUNaYzU0cG9KOHZxYXdkOFRyYU5yeVFlSm52SDFlTHBJRGdiaXF5bU0K
        localhost i686-linux,x86_64-linux /var/lib/hydra/id_ed25519 24 2 kvm,nixos-test,big-parallel,benchmark - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpUbGhGMmpmMTRSMGo4SXNEK25sM3cxQ0JxRVZaNmozWlB0MC8vSUlFSlQK
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
  # }}}

  # Kodi {{{
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
  # }}}
}
