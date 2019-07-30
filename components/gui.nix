let lib = import ../lib; in
lib.makeComponent "gui"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {
    audio = mkOption {
      default = true;
      type = types.bool;
    };
  };

  config = {
    # Use PulseAudio
    hardware.pulseaudio.enable = lib.mkIf cfg.audio true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.layout = "us";

    # Enable touchpad support.
    services.xserver.libinput.enable = true;

    # Fonts
    fonts.fonts = with pkgs; [ noto-fonts noto-fonts-emoji dejavu_fonts (import <unstable> {}).corefonts steamPackages.steam-fonts ];
    fonts.fontconfig.cache32Bit = true;

    # dconf
    programs.dconf.enable = true;
  };
})
