let lib = import ../lib; in
lib.makeComponent "en_us"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    # Select internationalisation properties.
    i18n = {
      consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "us";
      defaultLocale = "en_US.UTF-8";
    };
  };
})
