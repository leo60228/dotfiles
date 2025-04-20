{
  pkgs,
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
    fastfetch
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
    (callPackage ./neovim { })
    file
    unzip
    usbutils
    leoPkgs.bin
  ];

  programs.home-manager.enable = true;

  systemd.user.startServices = true;

  programs.bash.enable = true;
  programs.bash.initExtra = ''
    PROMPT_COLOR="1;2;37m"
    PS1='\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]$([ -z "$IN_NIX_SHELL" ] && echo "\u@\h" || echo nix-shell):\w]\\$\[\033[0m\] '
    export NIX_SHELL_PRESERVE_PROMPT=1

    [[ $- != *i* ]] && return

    eval $(hub alias -s)

    if [ -z "$NEOFETCH_RAN" ]; then
        fastfetch --config ${./files/fastfetch.jsonc}
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
