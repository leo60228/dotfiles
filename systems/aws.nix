# includes = ../rawConfig.nix:../hardware/aws.nix:../components/{mailserver,en_us,est,docker,extra,shellinabox,server,gui,reverseproxy,home}.nix
{ pkgs, ... }: with import ../components; rec {
  #components = mailserver en_us est docker extra shellinabox server gui { audio = false; } reverseproxy { host = "aws"; } home;
  components = en_us est docker extra shellinabox server gui { audio = false; } reverseproxy { host = "aws"; } home;

  networking.firewall.allowedTCPPorts = [ 22 80 443 21 2782 25565 ];
  networking.firewall.allowedUDPPorts = [ 2782 ];

  environment.systemPackages = with pkgs; [ conspy wget vim stress ];
  environment.sessionVariables.TERM = "vt100";

  systemd.services.codeserver = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.docker ];
    script = "./codeserver.sh";
    serviceConfig = {
      User = "leo60228";
      WorkingDirectory = "/home/leo60228/code-server-docker";
    };
  };

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

  services.xserver.enable = true;
  services.xserver.displayManager.leoxpra = {
    enable = true;
    bindTcp = "0.0.0.0:14500";
    extraOptions = [ "--tcp-auth=none" ":0" ];
  };

  services.postgresql.enable = true;
  services.redis.enable = true;

  boot.cleanTmpDir = true;
  networking.hostName = "leoservices";

  systemd.services.elixire = {
    description = "elixire";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = "export PATH=$PATH:/home/leo60228/.npm-global/bin:/home/leo60228/.nix-profile/bin; exec python3 run.py";
    environment.PYTHONPATH = "/home/leo60228/.local/lib/python3.6/site-packages/";
    environment.LD_LIBRARY_PATH = "/home/leo60228/.nix-profile/lib";
    serviceConfig.User = "leo60228";
    serviceConfig.WorkingDirectory = "/home/leo60228/elixire";
  };

  systemd.services.mastodon = {
    description = "mastodon";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.docker_compose ];
    script = "docker-compose up";
    serviceConfig.User = "leo60228";
    serviceConfig.WorkingDirectory = "/home/leo60228/mastodon";
  };

  systemd.services.writefreely = {
    description = "writefreely";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = "./writefreely";
    serviceConfig.User = "leo60228";
    serviceConfig.WorkingDirectory = "/home/leo60228/writefreely";
  };

  systemd.services.ghastly = {
    description = "ghastly";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = "${pkgs.callPackage ../celesters.nix {}}/bin/ghastly";
  };

  systemd.services.ghostbridge = {
    description = "ghostbridge";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = ''
    export DISCORD_TOKEN="$(< /var/keys/ghostbridge-token)"
    ${pkgs.callPackage ../celesters.nix {}}/bin/bridge celeste.0x0ade.ga:2782
    '';
    serviceConfig.Restart = "always";
  };

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
}
