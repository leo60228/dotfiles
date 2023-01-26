# includes = ../rawConfig.nix:../hardware/desktop.nix:../components/{efi,en_us,est,extra,gui,kde,steam,docker,home,vfio}.nix

{ config, pkgs, lib, ... }:

with import ../components; rec {
  components = efi en_us est extra { graalvm = true; } gui kde steam docker home { deviceScaleFactor = 2; } kvm glances flatpak prometheus ibus apcupsd { timeout = 300; minutes = 15; batteryLevel = 50; prometheus = "100.70.195.127"; } tailscale postgres mosh usbmuxd nixbuild firefox kdeconnect fwupd lxd;

  networking.firewall.allowedTCPPorts = (lib.range 3000 3010) ++ [ 34567 34568 22000 8010 6600 9999 ];
  networking.firewall.allowedUDPPorts = [ 4010 34567 34568 21027 6600 ];

  networking.hosts."52.218.200.91" = [ "www.blaseball2.com" ];

  security.pam.services.sshd.unixAuth = lib.mkForce true;

  services.openssh = {
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    extraConfig = ''
    Match Address 10.4.13.0/24,100.64.0.0/10,fd7a:115c:a1e0:ab12::/64
    	PasswordAuthentication yes
    	ChallengeResponseAuthentication yes
    '';
  };

  boot.binfmt.emulatedSystems = [ "armv7l-linux" ];

  services.mongodb.enable = true;

  services.hydra = {
    enable = true;
    hydraURL = "http://desktop:9999";
    port = 9999;
    notificationSender = "hydra@60228.dev";
    minimumDiskFree = 30;
    minimumDiskFreeEvaluator = 2;
    useSubstitutes = true;
    buildMachinesFiles = [ (pkgs.writeText "machines" ''
    eu.nixbuild.net aarch64-linux /var/lib/hydra/id_ed25519 100 1 big-parallel,benchmark - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSVBJUUNaYzU0cG9KOHZxYXdkOFRyYU5yeVFlSm52SDFlTHBJRGdiaXF5bU0K
    localhost i686-linux,x86_64-linux /var/lib/hydra/id_ed25519 24 2 kvm,nixos-test,big-parallel,benchmark - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpUbGhGMmpmMTRSMGo4SXNEK25sM3cxQ0JxRVZaNmozWlB0MC8vSUlFSlQK
    '') ];
  };

  services.postgresql.settings.max_connections = 200;
}
