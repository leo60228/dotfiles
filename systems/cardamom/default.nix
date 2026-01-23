{ lib, flakes, ... }:

{
  imports = [
    ./hardware.nix
    flakes.proxmox-nixos.nixosModules.proxmox-ve
  ];

  nixpkgs.overlays = [ flakes.proxmox-nixos.overlays.aarch64-linux ];

  services.proxmox-ve = {
    enable = true;
    ipAddress = "10.4.13.2";
    bridges = [ "vmbr0" ];
  };
  services.openssh.settings.AcceptEnv = lib.mkForce [
    "LANG"
    "LC_*"
  ];

  networking.useNetworkd = true;
  systemd.network = {
    enable = true;

    netdevs.vmbr0.netdevConfig = {
      Name = "vmbr0";
      Kind = "bridge";
    };

    networks = {
      "10-lan" = {
        matchConfig.Name = [ "end0" ];
        networkConfig.Bridge = "vmbr0";
      };

      "10-lan-bridge" = {
        matchConfig.Name = [ "vmbr0" ];
        networkConfig = {
          IPv6AcceptRA = true;
          DHCP = "ipv4";
        };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };

  system.stateVersion = "26.05";
}
