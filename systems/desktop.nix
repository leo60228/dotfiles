# includes = ../rawConfig.nix:../hardware/desktop.nix:../components/{efi,en_us,est,extra,gui,kde,steam,docker,home,vfio}.nix

{
  config,
  pkgs,
  lib,
  ...
}:

with import ../components;
rec {
  components =
    efi en_us extra gui kde steam docker home { deviceScaleFactor = 2; } kvm flatpak prometheus apcupsd
      {
        timeout = 300;
        minutes = 15;
        batteryLevel = 50;
      }
      tailscale
      nixbuild
      kdeconnect
      fwupd;

  system.stateVersion = "18.03";

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

  networking.hosts."52.218.200.91" = [ "www.blaseball2.com" ];

  security.pam.services.sshd.unixAuth = lib.mkForce true;

  services.openssh = {
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    extraConfig = ''
      Match Address 10.4.13.0/24,100.64.0.0/10,fd7a:115c:a1e0:ab12::/64
      	PasswordAuthentication yes
      	ChallengeResponseAuthentication yes
    '';
  };

  boot.binfmt.emulatedSystems = [ "armv7l-linux" ];

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

  nix.settings.allowed-uris = [
    "github:"
    "https://github.com"
    "git+https://github.com"
    "gitlab:"
    "https://gitlab.com"
    "git+https://gitlab.com"
  ];

  services.postgresql.settings.max_connections = 200;

  services.tailscale.useRoutingFeatures = "both";

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

  services.postgresql.package = pkgs.postgresql_16;
}
