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

  services.openssh.extraConfig = ''
  TrustedUserCAKeys ${../files/ssh-ca.pub}
  '';

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
    openssh git
  ];

  services.openssh.enable = true;

  boot.initrd.extraUtilsCommands = ''
    copy_bin_and_libs ${pkgs.e2fsprogs}/sbin/resize2fs
  '';

  boot.kernel.sysctl."kernel.sysrq" = 1;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0955", ATTR{idProduct}=="7321", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="8b00", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0200|0402|0403|0406|0407|0410", TAG+="uaccess", GROUP="users", MODE="0666"
    ATTRS{name}=="Logitech M570", ENV{IS_M570}="yes"
    ENV{IS_M570}=="yes", SYMLINK+="input/event_m570"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0a5c", ATTRS{idProduct}=="21e8", TAG+="uaccess"
    ATTRS{id/vendor}=="057e", ATTRS{id/product}=="2009", TAG+="uaccess", MODE="0666"
  '';

  # tmpfs
  boot.tmpOnTmpfs = true;

  services.openssh.forwardX11 = true;

  security.sudo.wheelNeedsPassword = false;
}
