{
  callPackage,
  nodejs_18,
  python3,
  libsForQt5,
  qt6,
  kdePackages,
}:

rec {
  bin = callPackage ./bin { };
  citra = callPackage ./citra { };
  crabstodon = callPackage ./crabstodon { };
  eontimer = libsForQt5.callPackage ./eontimer { inherit qtsass; };
  datapath-vision = kernelPackages: kernelPackages.callPackage ./datapath-vision { };
  datapath-vision-firmware = callPackage ./datapath-vision-firmware { };
  determination-fonts = callPackage ./determination-fonts { };
  discord = callPackage ./discord { };
  hactoolnet = callPackage ./hactoolnet { };
  hyfetch = callPackage ./hyfetch { };
  mastodon = callPackage ./mastodon { };
  office-2007-fonts = callPackage ./office-2007-fonts { };
  pam-fprint-grosshack = callPackage ./pam-fprint-grosshack { };
  qtsass = python3.pkgs.toPythonApplication (python3.pkgs.callPackage ./qtsass { });
  redumper = callPackage ./redumper { };
  reposilite = callPackage ./reposilite { };
  rust = callPackage ./rust { };
  sddm-theme-breeze-user = kdePackages.callPackage ./sddm-theme-breeze-user { };
  twemoji-ttf = callPackage ./twemoji-ttf { };
  udisks2 = callPackage ./udisks/2-default.nix { };
  vscode-fhs = callPackage ./vscode-fhs { };
  vxis-capture-fw-mod = callPackage ./vxis-capture-fw-mod { };
}
