{ pkgs, lib, config, flakes, ... }:

{
  imports = [ ./xpra.nix ./mastodon.nix ./flakes.nix ./nix-daemon.nix ];

  users.extraUsers.leo60228 = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "dialout" "video" "render" ];
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
  };

  users.users.root.openssh.authorizedKeys.keys = let
    text = builtins.readFile ../files/authorized_keys;
    split = lib.splitString "\n" text;
    keys = builtins.filter (x: x != "") split;
  in keys;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

  nixpkgs.overlays = map (e:
    let
      rawOverlay = import (../nixpkgs + ("/" + e));
      hasArgs = builtins.functionArgs rawOverlay != {};
      overlay = if hasArgs then rawOverlay flakes else rawOverlay;
    in overlay
  ) (builtins.attrNames (builtins.readDir ../nixpkgs));
  nixpkgs.config = { allowUnfree = true; };

  # trusted users
  nix.trustedUsers = [ "root" "@wheel" ];

  environment.systemPackages = with pkgs; [
    openssh
  ];

  services.openssh.enable = true;

  boot.initrd.extraUtilsCommands = ''
    copy_bin_and_libs ${pkgs.e2fsprogs}/sbin/resize2fs
  '';

  boot.kernel.sysctl."kernel.sysrq" = 1;
}
