# includes = ../rawConfig.nix:../hardware/aws.nix:../components/{mailserver,en_us,est,docker,extra,shellinabox,server,gui,reverseproxy,home}.nix
{ pkgs, ... }: with import ../components; rec {
  #components = mailserver en_us est docker extra shellinabox server gui { audio = false; } reverseproxy { host = "aws"; } home;
  #components = en_us est docker extra shellinabox server gui { audio = false; } reverseproxy { host = "aws"; } home;
  components = en_us est docker extra server gui { audio = false; } reverseproxy { host = "aws"; } home { small = true; };

  networking.firewall.allowedTCPPorts = [ 22 80 443 21 2782 5222 5269 5280 5443 ];
  networking.firewall.allowedUDPPorts = [ 2782 25565 ];

  environment.systemPackages = with pkgs; [ conspy wget vim stress ];

  #systemd.services.codeserver = {
  #  wantedBy = [ "multi-user.target" ];
  #  path = [ pkgs.docker ];
  #  script = "./codeserver.sh";
  #  serviceConfig = {
  #    User = "leo60228";
  #    WorkingDirectory = "/home/leo60228/code-server-docker";
  #  };
  #};

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

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_14;
  services.redis.enable = true;

  boot.cleanTmpDir = true;

  services.mastodon = {
    enable = true;
    enableUnixSocket = false;
    #package = "/home/leo60228/mastodon-src-current/";
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
    };
  };

  #systemd.services.ghastly = {
  #  description = "ghastly";
  #  wantedBy = [ "multi-user.target" ];
  #  after = [ "network.target" ];
  #  script = "${pkgs.callPackage ../celesters.nix {}}/bin/ghastly";
  #};

  #systemd.services.ghostbridge = {
  #  description = "ghostbridge";
  #  wantedBy = [ "multi-user.target" ];
  #  after = [ "network.target" ];
  #  script = ''
  #  export DISCORD_TOKEN="$(< /var/keys/ghostbridge-token)"
  #  ${pkgs.callPackage ../celesters.nix {}}/bin/bridge celeste.0x0ade.ga:2782
  #  '';
  #  serviceConfig.Restart = "always";
  #};

  users.extraUsers.thefox = {
    isNormalUser = true;
    shell = pkgs.shadow;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFN9j+mJvYm9IVkcpgN2exgeryB6TOOazG9EKSKbd5djIUk4Kgy8hQzJWW+zD3OIR4WCezeYTC7Cckpz3MpBlJxaF+clUQNTzz/Xs6ROonnnp8A/YUy1eqfuKLVbM+67WOLIwiNZdklTuVVD79sUsDwyxdpUfQfNbLUZxyyG6itw/g/lDWGzd28D4YY1IJTCyTF/53bwFhlWDiOr+1lklw4oCvgWa3rYQEtHfXWMKtY93wZNUUaI4RxJ2PO/cgCZGgkwiLJTZ6mgWBrxjmYg6Pi8VLy5aWiTIyc+X9z28ycT6cULd/xEpXBFiEvANsme+ChxTNOhiXGosIDFPhndAV thefox@foxs-pc"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9YgtqLs76ZQHml8rzwRzJgR1xWmeBAZ+NTXCX3UQ63vmKOYCzQn5WbDiKxs5dIPq1cFYHMnx2QstGYmRyAS8DCyhGYciu8BIXG/4lswWmheOhuQDM2sEgqZSOUekf5W+f9fxvkZwem7oZfTJk/WGs0junbCpvTl/lFZts8qX7osyhHQ4AtbUKzj9vwsAukwgzzGXAUhT9+Fqs9j4lWmRJGRH4lN0wvsAXpufLR5GAjS0IWazo/xleMVSz8AOYY0kA8yn5TzQq5RAuN6zUE8LiIFBrO0QKiTIwpXGj7FF7+ULFXYTHy8AwsagN5Fn6HWMKqAWaLwh7RtKGzhQAmx1n leo60228@digitaleo"
    ];
  };

  networking.wireguard.enable = true;
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.9.0.2/32" ];
    privateKeyFile = "/var/keys/wireguard";
    peers = [
      {
        publicKey = "Y4VJQCdUnyANBWU9+Ce8E4Sjs54oycrJc9ODH84FMjo=";
        allowedIPs = [ "192.168.1.0/24" ];
        endpoint = "98.121.248.25:43331";
        persistentKeepalive = 25;
      }
    ];
  };

#  networking.firewall.extraCommands = ''
#iptables -A FORWARD -i ens5 -o wg0 -p tcp --syn --dport 25565 -m conntrack --ctstate NEW -j ACCEPT
#iptables -A FORWARD -i ens5 -o wg0 -p udp --dport 25565 -m conntrack --ctstate NEW -j ACCEPT
#iptables -A FORWARD -i ens5 -o wg0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -i wg0 -o ens5 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#iptables -t nat -A PREROUTING -i ens5 -p tcp --dport 25565 -j DNAT --to-destination 192.168.1.140
#iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 25565 -d 192.168.1.140 -j SNAT --to-source 10.9.0.2
#iptables -t nat -A PREROUTING -i ens5 -p udp --dport 25565 -j DNAT --to-destination 192.168.1.140
#iptables -t nat -A POSTROUTING -o wg0 -p udp --dport 25565 -d 192.168.1.140 -j SNAT --to-source 10.9.0.2
#
#  '';
#  boot.kernel.sysctl = {
#    "net.ipv4.conf.all.forwarding" = true;
#    "net.ipv4.conf.default.forwarding" = true;
#  };

  #services.matrix-synapse = {
  #  enable = true;
  #  server_name = "60228.dev";
  #  public_baseurl = "https://60228.dev/";
  #  listeners = [
  #    {
  #      port = 8008;
  #      bind_address = "127.0.0.1";
  #      type = "http";
  #      tls = false;
  #      x_forwarded = true;
  #      resources = [
  #        { names = [ "client" ]; compress = true; }
  #        { names = [ "federation" ]; compress = false; }
  #      ];
  #    }
  #  ];
  #  url_preview_enabled = true;
  #  extraConfig = ''
  #  suppress_key_server_warning: true
  #  '';
  #};

  #services.ejabberd = {
  #  enable = true;
  #  configFile = ../files/ejabberd.yml;
  #  imagemagick = true;
  #};

  security.acme.certs."60228.dev".group = "acme";
  users.users.nginx.extraGroups = [ "acme" ];

  #systemd.services.nginx.serviceConfig.ProtectHome = false;
}
