{
  nixos = { pkgs, lib, ... }: {
    imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-raspberrypi4.nix> ];

    networking.wireless.enable = false;

    sdImage.populateRootCommands = "touch files/dummy.txt";
  };

  nixops.deployment.targetHost = "10.4.13.1";
}
