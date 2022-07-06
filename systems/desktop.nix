# includes = ../rawConfig.nix:../hardware/desktop.nix:../components/{efi,en_us,est,extra,gui,kde,steam,docker,home,vfio}.nix

{ config, pkgs, lib, ... }:

with import ../components; rec {
  components = efi en_us est extra { graalvm = true; } gui { autoLogin = true; } kde steam docker home { deviceScaleFactor = 2; } kvm glances flatpak mqtt prometheus ibus apcupsd { timeout = 300; minutes = 15; batteryLevel = 50; prometheus = "100.70.195.127"; } tailscale postgres mosh usbmuxd nixbuild firefox kdeconnect fwupd;

  networking.firewall.allowedTCPPorts = (lib.range 3000 3010) ++ [ 34567 34568 22000 8010 6600 ];
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
}
