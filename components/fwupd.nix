let lib = import ../lib; in
lib.makeComponent "fwupd"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    services.fwupd.enable = true;
    environment.systemPackages = with pkgs; [ plasma5Packages.discover ];
  };
})
