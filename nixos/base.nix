# vi: set foldmethod=marker:

{
  pkgs,
  lib,
  config,
  flakes,
  ...
}:

{
  imports = [
    ./cachix.nix
    ./workstation.nix
    ./graphical.nix
    ./prometheus.nix
    ./apcupsd.nix
    ./zfs-credstore.nix

    # dependencies
    flakes.home-manager.nixosModules.home-manager
    "${flakes.hydra}/nixos-modules/hydra.nix"
    flakes.lix-module.nixosModules.default
  ];

  # SSH {{{1
  services.openssh = {
    enable = true;

    settings = {
      X11Forwarding = true;
      StreamLocalBindUnlink = true;
      GatewayPorts = "yes";
      TrustedUserCAKeys = "${../files/ssh-ca.pub}";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      UseDns = true;
    };

    extraConfig = ''
      Match Address 10.4.13.0/24,100.64.0.0/10,fd7a:115c:a1e0:ab12::/64
      	PasswordAuthentication yes
      	ChallengeResponseAuthentication yes
    '';
  };

  security.pam.services.sshd.unixAuth = lib.mkForce true;

  users.users.root.openssh.authorizedKeys.keys =
    let
      text = builtins.readFile ../files/authorized_keys;
      split = lib.splitString "\n" text;
      keys = builtins.filter (x: x != "") split;
    in
    keys;

  # Users {{{1
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

  home-manager = {
    useGlobalPkgs = true;
    users.leo60228 = import ../home.nix;
    extraSpecialArgs = { inherit flakes; };
  };

  security.sudo.wheelNeedsPassword = false;

  # Nixpkgs {{{1
  nixpkgs = {
    overlays = [
      flakes.hydra.overlays.default
    ]
    ++ map (
      e:
      let
        rawOverlay = import (../overlays + ("/" + e));
        hasArgs = builtins.functionArgs rawOverlay != { };
        overlay = if hasArgs then rawOverlay flakes else rawOverlay;
      in
      overlay
    ) (builtins.attrNames (builtins.readDir ../overlays));
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16" # these vulnerabilities aren't real.
        "dotnet-core-combined"
        "dotnet-sdk-6.0.428"
        "dotnet-sdk-wrapped-6.0.428"
      ];
    };
  };

  # Nix {{{1
  nix = {
    settings =
      let
        substituters = [
          "https://cache.nixos.org/"
        ]
        ++ lib.optional (config.networking.hostName != "desktop") "http://desktop:9999";
      in
      {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
        allowed-uris = [
          "https://github.com"
          "https://gitlab.com"
          "https://git.sr.ht"
          "https://git.lix.systems"
          "https://git@git.lix.systems"
        ];
        trusted-public-keys = [ "desktop-1:jpWiJK7Ltbcf1b9xr9mx/4on1NqqmqTZG4bldBl41oQ=" ];
        inherit substituters;
        trusted-substituters = substituters;
        warn-dirty = false;
      };
    extraOptions = "!include /etc/nix/secrets.conf"; # put a GitHub PAT here!
  };

  # Packages {{{1
  environment.systemPackages = with pkgs; [
    openssh
    git
    tailscale
  ];

  boot.initrd.extraUtilsCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
    copy_bin_and_libs ${pkgs.e2fsprogs}/sbin/resize2fs
  '';

  boot.initrd.systemd.initrdBin = lib.mkIf (config.boot.initrd.systemd.enable) [ pkgs.e2fsprogs ];

  services.tailscale.enable = true;

  # Kernel {{{1
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
    ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="5014", TAG+="uaccess", MODE="0666"
    ATTRS{idVendor}=="05c6", ATTRS{idProduct}=="9008", TAG+="uaccess", MODE="0666"
  '';
  services.udev.packages = [
    (pkgs.runCommand "udev-rules" { } ''
      mkdir -vp $out/etc/udev/rules.d
      cp -vt $out/etc/udev/rules.d ${../files/51-ftd3xx.rules} ${../files/80-m1n1.rules} ${../files/mchp-udev}/*
    '')
  ];

  # Filesystems {{{1
  boot.tmp.useTmpfs = true;
  networking.hostId = builtins.substring 0 8 (
    builtins.hashString "sha256" config.networking.hostName
  );

  # increase inotify limits (per upstream recommendation, see kernel commits
  # 92890123749bafc317bbfacbe0a62ce08d78efb7 and ac7b79fd190b02e7151bc7d2b9da692f537657f3)
  boot.kernel.sysctl."fs.inotify.max_user_instances" = 2147483647;
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;

  # Internationalization {{{1
  console = {
    font = lib.mkDefault "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = "America/New_York";
  # }}}
}
