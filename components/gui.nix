let lib = import ../lib; in
lib.makeComponent "gui"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {
    audio = mkOption {
      default = true;
      type = types.bool;
    };
    autoLogin = mkOption {
      default = false;
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
    fonts.fonts = with pkgs; [ noto-fonts noto-fonts-emoji dejavu_fonts corefonts steamPackages.steam-fonts ];
    fonts.fontconfig.cache32Bit = true;

    # dconf
    programs.dconf.enable = true;

    # auto-login
    services.xserver.displayManager.autoLogin = lib.mkIf cfg.autoLogin {
      enable = true;
      user = "leo60228";
    };
  };
})
