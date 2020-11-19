{ config, pkgs, ... }:

with import ../components; {
  imports = [ ../cachix.nix ];

  components = efi en_us est gui kde steam extra home { small = true; };

  users.extraUsers.leo60228.extraGroups = [ "wheel" ];

  environment.sessionVariables.KDEWM = "${pkgs.openbox}/bin/openbox";
}
