let lib = import ../lib; in
lib.makeComponent "efi"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {
    removable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;
  };
})
