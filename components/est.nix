let lib = import ../lib; in
lib.makeComponent "est"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    # Set your time zone.
    time.timeZone = "America/New_York";
  };
})
