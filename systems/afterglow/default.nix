{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "25.05";

  vris.graphical = true;

  services.displayManager.sessionPackages = [ pkgs.kdePackages.plasma-mobile ];
  services.displayManager.sddm.wayland.compositorCommand = lib.concatStringsSep " " [
    "${lib.getBin pkgs.kdePackages.kwin}/bin/kwin_wayland"
    "--no-global-shortcuts"
    "--no-kactivities"
    "--no-lockscreen"
    "--locale1"
    "--inputmethod"
    "maliit-keyboard"
  ];
  environment.systemPackages = [
    pkgs.maliit-framework
    pkgs.maliit-keyboard
  ];
}
