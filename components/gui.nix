let lib = import ../lib; in
lib.makeComponent "gui"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {
    firefox = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = {
    # Use PulseAudio
    hardware.pulseaudio.enable = true;
    
    environment.systemPackages = with pkgs; [
      (if cfg.firefox then firefox else google-chrome) 
    ];

    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.layout = "us";

    # Enable touchpad support.
    services.xserver.libinput.enable = true;

    # Fonts
    fonts.fonts = with pkgs; [ noto-fonts noto-fonts-emoji dejavu_fonts ];
  };
})
