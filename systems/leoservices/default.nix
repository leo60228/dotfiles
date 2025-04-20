# vi: set foldmethod=marker:

{ config, pkgs, ... }:
with import ../../components;
rec {
  imports = [
    ./hardware.nix
    ./reverseproxy.nix
  ];

  system.stateVersion = "18.03";

  environment.systemPackages = with pkgs; [
    conspy
    wget
    vim
    stress
  ];

  # Networking {{{1
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    21
    2782
    5222
    5269
    5280
    5443
  ];
  networking.firewall.allowedUDPPorts = [
    2782
    25565
  ];

  # Minecraft {{{1
  systemd.services.minecraft = {
    enable = false;
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.jre8 ];
    script = "java -XX:+UseG1GC -Xmx3G -Xms3G -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -jar ./FTBserver.jar nogui";
    restartIfChanged = false; # 20 minutes later...
    serviceConfig = {
      StandardInput = "tty-force";
      TTYVHangup = "yes";
      TTYPath = "/dev/tty20";
      TTYReset = "yes";
      Restart = "always";
      User = "root";
      WorkingDirectory = "/root/minecraft";
    };
  };

  # PDS {{{1
  virtualisation.docker.enable = true;
  systemd.services.pds = {
    requires = [ "docker.service" ];
    after = [ "docker.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "/var/lib/pds";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose --file /var/lib/pds/compose.yaml up --detach";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose --file /var/lib/pds/compose.yaml down";
    };

    wantedBy = [ "multi-user.target" ];
  };

  security.acme.certs."pds.vriska.dev" = {
    domain = "*.pds.vriska.dev";
    extraDomainNames = [ "pds.vriska.dev" ];
    dnsProvider = "cloudflare";
    credentialsFile = "/var/lib/pds/cloudflare-token";
  };

  # Mastodon {{{1
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_14;
  services.redis.servers."".enable = true;

  services.mastodon = {
    enable = true;
    enableUnixSocket = false;
    package = pkgs.leoPkgs.crabstodon;
    streamingProcesses = 1;
    extraEnvFiles = [
      "/var/lib/mastodon/.extra_secrets_env"
    ];
    localDomain = "60228.dev";
    smtp = {
      createLocally = false;
      host = "smtp-relay.gmail.com";
      port = 587;
      authenticate = false;
      fromAddress = "Administrator <admin@60228.dev>";
    };
    extraConfig = {
      MAX_TOOT_CHARS = "10000";
      MAX_DISPLAY_NAME_CHARS = "100";
      MAX_POLL_OPTIONS = "15";
      MAX_PROFILE_FIELDS = "15";

      GITHUB_REPOSITORY = "BlaseballCrabs/mastodon";
      SOURCE_TAG = config.services.mastodon.package.src.rev;
    };
  };

  security.acme.certs."60228.dev".group = "acme";
  users.users.nginx.extraGroups = [ "acme" ];
  users.groups.mastodon.members = [ "nginx" ];
  # }}}
}
