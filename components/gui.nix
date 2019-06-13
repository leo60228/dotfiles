let lib = import ../lib; in
lib.makeComponent "gui"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    # Use PulseAudio
    hardware.pulseaudio.enable = true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.layout = "us";

    # Enable touchpad support.
    services.xserver.libinput.enable = true;

    # Fonts
    fonts.fonts = with pkgs; [ noto-fonts noto-fonts-emoji dejavu_fonts corefonts ];
  };
})
