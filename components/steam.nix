let lib = import ../lib; in
lib.makeComponent "steam"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    # Steam
    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.setLdLibraryPath = true;
    hardware.pulseaudio.support32Bit = true;
    environment.systemPackages = [ ((pkgs.newScope pkgs.steamPackages) <nixpkgs/pkgs/games/steam/chrootenv.nix> {
      glxinfo-i686 = pkgs.pkgsi686Linux.glxinfo;
      steam-runtime-wrapped-i686 =
        if pkgs.stdenv.hostPlatform.system == "x86_64-linux"
        then pkgs.pkgsi686Linux.steamPackages.steam-runtime-wrapped
        else null;
    }) ];

    services.udev.extraRules = builtins.replaceStrings ["0660"] ["0666"] (builtins.readFile ../files/steam-input.rules);
  };
})
