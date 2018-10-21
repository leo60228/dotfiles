path:

{ pkgs, ... }:

let gmusicproxy = import "${path}/gmusicproxy.nix";
in {
  home.packages = with pkgs; [
    gist
    gitAndTools.hub
    appimage-run
    p7zip
    #gimpPlugins.gap
    steam-run-native
    vscode
    discord
    gimp
    google-musicmanager
    symbola
    kitty
    (python36.withPackages (ps: with ps; [ pyusb ]))
    python27
    #(obs-studio.override {
    #  ffmpeg = ffmpeg-full.override {
    #    inherit nvidia-video-sdk;
    #    nvenc = true;
    #    nonfreeLicensing = true;
    #  };
    #})
    #frei0r
    #(ffmpeg-full.override {
    #  inherit nvidia-video-sdk;
    #  nvenc = true;
    #  nonfreeLicensing = true;
    #})
    #kdeApplications.kdenlive
    vlc
    multimc
    #dolphinEmuMaster
    openalSoft
    multimc
    vimHugeX
    openscad
    dpkg
    binutils-unwrapped
    slic3r-prusa3d
    sdcc
    mgba
    filezilla
    rustup
    nasm
    grub2
    xorriso
    qemu
    google-chrome-beta
    gitAndTools.git-annex
    gitAndTools.gitFull
    mr
    stow
    file
    gpx
    pciutils
    unzip
    tigervnc
    usbutils
    #dotnetPackages.Nuget
    wine
    gnumake
    gcc
    meteor
    hplip
    virtualbox
    dotnet-sdk
    gmusicproxy
    #julia_06
    (pkgs.hiPrio (import "${path}/bin.nix" pkgs))
    (callPackage ./fuseenano.nix {})
  ];

  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;

  systemd.user.services.gmusicproxy = {
    Unit = {
      Description = "play music proxy";
      After = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${gmusicproxy}/bin/gmusicproxy";
      Restart = "always";
    };

    Install = {
      WantedBy = [ "network-online.target" ];
    };
  };

  programs.bash.enable = true;
  programs.bash.initExtra = ''
    export PATH="$HOME/.bin/:$PATH:$HOME/.cargo/bin"

    export NIX_REMOTE=daemon

    if [[ "$KEYCHAIN_RAN" != "1" ]]; then
      eval `nix run nixpkgs.keychain -c keychain --agents ssh --eval id_rsa`
      export KEYCHAIN_RAN=1
    fi

    export GITHUB_TOKEN="2f1939ec3e70118cef6b6894de522015036d873b"
    eval $(hub alias -s)
  '';

  xdg.configFile."kitty/kitty.conf".text = ''
    remember_window_size no
    initial_window_width 1700
    initial_window_height 1100
  '';

  home.file.".mrconfig".source = ./mrconfig;

  home.file.".frei0r-1/lib".source = "${pkgs.frei0r}/lib/frei0r-1";
  home.file.".frei0r-1/lib".recursive = true;

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

  nixpkgs.overlays = map (e: import "${path}/nixpkgs/${e}") (builtins.attrNames (builtins.readDir ./nixpkgs));
  nixpkgs.config.allowUnfree = true;
}
