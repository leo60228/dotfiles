{
  pkgs,
  osConfig,
  config,
  lib,
  ...
}:

{
  imports = [
    ./home/graphical.nix
    ./home/workstation.nix
  ];

  home.stateVersion = "21.05";
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    htop
    imagemagick
    alsa-utils
    ripgrep
    zip
    efibootmgr
    jq
    pciutils
    bat
    screen
    irssi
    gist
    p7zip
    python3
    (callPackage ./neovim { inherit (osConfig.vris) workstation; })
    file
    unzip
    usbutils
    leoPkgs.bin
  ];

  programs.git = {
    enable = true;
    userName = "leo60228";
    userEmail = "leo@60228.dev";
    extraConfig.init.defaultBranch = "main";
    extraConfig.hub.protocol = "ssh";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = true;

  programs.fastfetch = {
    enable = true;
    settings = {
      modules =
        [
          "title"
          "separator"
          "os"
          {
            type = "command";
            key = "Host";
            text = "fastfetch --pipe -l none --key-type none -s host --host-format '{name}' | sed 's/^Laptop/Framework &/;T;s/7040S/7040 S/'";
          }
          "kernel"
          "uptime"
          "shell"
        ]
        ++ (lib.optionals osConfig.vris.graphical [
          {
            type = "display";
            compactType = "original-with-refresh-rate";
          }
          {
            type = "command";
            key = "DE";
            text = "[ -z \"$XDG_SESSION_TYPE\" ] && exit; echo \"Plasma $(dbus-send --dest=org.kde.plasmashell --print-reply=literal /MainApplication org.freedesktop.DBus.Properties.Get string:org.qtproject.Qt.QCoreApplication string:applicationVersion | sed 's/^ *variant *//') [Frameworks $(dbus-send --dest=org.kde.kded6 --print-reply=literal /MainApplication org.freedesktop.DBus.Properties.Get string:org.qtproject.Qt.QCoreApplication string:applicationVersion | sed 's/^ *variant *//')] ($XDG_SESSION_TYPE)\"";
          }
        ])
        ++ [
          "cpu"
        ]
        ++ (lib.optional osConfig.vris.graphical (
          if osConfig.services.xserver.videoDrivers != [ "nvidia" ] then
            {
              type = "gpu";
              driverSpecific = true;
              format = "{name} ({core-count}) @ {frequency} ({driver})";
            }
          else
            "gpu"
        ))
        ++ [
          "memory"
          "disk"
          {
            type = "battery";
            key = "Battery";
          }
          {
            type = "localip";
            compact = true;
            showPrefixLen = false;
          }
        ];
      logo.color = {
        "1" = "38;2;74;107;175";
        "2" = "38;2;126;177;221";
      };
    };
  };

  programs.bash.enable = true;
  programs.bash.initExtra = ''
    PROMPT_COLOR="1;2;37m"
    PS1='\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]$([ -z "$IN_NIX_SHELL" ] && echo "\u@\h" || echo nix-shell):\w]\\$\[\033[0m\] '
    export NIX_SHELL_PRESERVE_PROMPT=1

    [[ $- != *i* ]] && return

    if [ -z "$NEOFETCH_RAN" ]; then
        fastfetch
        export NEOFETCH_RAN=1
    fi
  '';

  home.sessionVariables = {
    EDITOR = "vim";
    RUSTFMT = "rustfmt";
  };

  programs.bash.shellAliases = {
    cat = "bat";
    sudo = "sudo ";
  };

  home.file.".inputrc".text = ''
    $include /etc/inputrc
    "\e[A":history-search-backward
    "\e[B":history-search-forward
    set enable-bracketed-paste on
  '';

  home.file.".XCompose".source = ./files/XCompose;

  xdg.configFile."nixpkgs/config.nix".source = ./files/nixpkgs-config.nix;

  programs.msmtp = {
    enable = true;
  };

  accounts.email.accounts."leo@60228.dev" = {
    primary = true;
    flavor = "gmail.com";
    address = "leo@60228.dev";
    realName = "leo60228";
    userName = "leo@60228.dev";
    msmtp.enable = true;
    msmtp.extraConfig.auth = "oauthbearer";
    passwordCommand = "${pkgs.oama}/bin/oama access leo@60228.dev";
  };
}
