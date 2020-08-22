{
  nixos = { pkgs, lib, ... }: {
    imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-raspberrypi4.nix> ];

    networking.wireless.enable = false;

    sdImage.populateRootCommands = "touch files/dummy.txt";

    systemd.network.links = {
      internal0 = {
	matchConfig.MACAddress = "dc:a6:32:43:78:51";
	linkConfig.Name = "internal0";
      };
      external0 = {
	matchConfig.MACAddress = "00:0e:c6:8f:34:ce";
	linkConfig.Name = "external0";
      };
    }; 
  };

  nixops.deployment.targetHost = "10.4.13.1";
}
