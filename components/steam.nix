let lib = import ../lib; in
lib.makeComponent "steam"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    # Steam
    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.setLdLibraryPath = true;
    hardware.pulseaudio.support32Bit = true;
    environment.systemPackages = with pkgs; [ steam ];

    hardware.steam-hardware.enable = true;
  };
})
