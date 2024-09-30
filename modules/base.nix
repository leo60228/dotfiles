{
  pkgs,
  lib,
  config,
  flakes,
  ...
}:

{
  imports = [
    ./flakes.nix
    ./nix-daemon.nix
    ./cachix.nix

    ./mastodon.nix # FIXME: remove after https://github.com/NixOS/nixpkgs/pull/337545
  ];
  disabledModules = [ "services/web-apps/mastodon.nix" ];

  users.extraUsers.leo60228 = {
    isNormalUser = true;
    uid = 1000;
    autoSubUidGidRange = true;
    extraGroups = [
      "wheel"
      "dialout"
      "video"
      "render"
      "cdrom"
    ];
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
  };

  users.users.root.openssh.authorizedKeys.keys =
    let
      text = builtins.readFile ../files/authorized_keys;
      split = lib.splitString "\n" text;
      keys = builtins.filter (x: x != "") split;
    in
    keys;

  services.openssh.extraConfig = ''
    TrustedUserCAKeys ${../files/ssh-ca.pub}
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

  nixpkgs.overlays = map (
    e:
    let
      rawOverlay = import (../nixpkgs + ("/" + e));
      hasArgs = builtins.functionArgs rawOverlay != { };
      overlay = if hasArgs then rawOverlay flakes else rawOverlay;
    in
    overlay
  ) (builtins.attrNames (builtins.readDir ../nixpkgs));
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "olm-3.2.16" # these vulnerabilities aren't real.
    ];
  };

  # trusted users
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];
  nix.settings.allowed-uris = [
    "https://github.com"
    "https://gitlab.com"
    "https://git.sr.ht"
    "https://git.lix.systems"
    "https://git@git.lix.systems"
  ];
  nix.settings.trusted-public-keys = [ "desktop-1:jpWiJK7Ltbcf1b9xr9mx/4on1NqqmqTZG4bldBl41oQ=" ];
  nix.settings.substituters =
    if config.networking.hostName == "desktop" then
      [ ]
    else
      [
        "https://cache.nixos.org/"
        "http://desktop:9999"
      ];
  nix.settings.trusted-substituters =
    if config.networking.hostName == "desktop" then
      [ "https://cache.nixos.org/" ]
    else
      [
        "https://cache.nixos.org/"
        "http://desktop:9999"
      ];
  nix.extraOptions = "!include /etc/nix/secrets.conf";

  environment.systemPackages = with pkgs; [
    openssh
    git
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
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0004", ATTRS{serial}=="E66038B71359BA2F", TAG+="uaccess", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0aa7", TAG+="uaccess", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", TAG+="uaccess", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="0109", TAG+="uaccess", MODE="0666"
    ATTRS{id/vendor}=="057e", ATTRS{id/product}=="2009", TAG+="uaccess", MODE="0666"
    ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2175", TAG+="uaccess", MODE="0666"
    ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2145", TAG+="uaccess", MODE="0666"
    ATTRS{idVendor}=="1781", ATTRS{idProduct}=="0c9f", TAG+="uaccess", MODE="0666"
  '';
  services.udev.packages = [
    (pkgs.runCommand "udev-rules" { } ''
      mkdir -vp $out/etc/udev/rules.d
      cp -vt $out/etc/udev/rules.d ${../files/51-ftd3xx.rules} ${../files/80-m1n1.rules} ${../files/mchp-udev}/*
    '')
  ];

  # tmpfs
  boot.tmp.useTmpfs = true;

  services.openssh.settings.X11Forwarding = true;
  services.openssh.settings.StreamLocalBindUnlink = true;

  security.sudo.wheelNeedsPassword = false;

  # increase inotify limits (per upstream recommendation, see kernel commits
  # 92890123749bafc317bbfacbe0a62ce08d78efb7 and ac7b79fd190b02e7151bc7d2b9da692f537657f3)
  boot.kernel.sysctl."fs.inotify.max_user_instances" = 2147483647;
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;
}
