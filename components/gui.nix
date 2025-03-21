let
  lib = import ../lib;
in
lib.makeComponent "gui" (
  {
    cfg,
    pkgs,
    lib,
    ...
  }:
  with lib;
  {
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
      # Use PipeWire
      security.rtkit.enable = lib.mkIf cfg.audio true;
      services.pipewire = lib.mkIf cfg.audio {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        jack.enable = true;
      };
      systemd.user.services.wireplumber.environment.ACP_PROFILES_DIR =
        lib.mkIf cfg.audio ../files/profile-sets;

      # Enable the X11 windowing system.
      services.xserver.enable = true;
      services.xserver.xkb.layout = "us";

      # Enable touchpad support.
      services.libinput.enable = true;

      # Fonts
      fonts.enableDefaultPackages = false;
      fonts.packages = with pkgs; [
        dejavu_fonts
        freefont_ttf
        gyre-fonts
        liberation_ttf
        unifont
        unifont_upper
        noto-fonts
        noto-fonts-cjk-sans
        corefonts
      ];
      fonts.fontconfig.cache32Bit = true;

      # dconf
      programs.dconf.enable = true;

      # auto-login
      services.displayManager.autoLogin = lib.mkIf cfg.autoLogin {
        enable = true;
        user = "leo60228";
      };
    };
  }
)
