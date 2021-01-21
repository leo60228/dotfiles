let lib = import ../lib; in
lib.makeComponent "ibus"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [];
    };
  };
})
