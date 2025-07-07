{
  callPackage,
  callPackages,
  python3,
  libsForQt5,
  qt6,
  kdePackages,
}:

rec {
  avmvc12 = callPackage ./avmvc12 { };
  bin = callPackage ./bin { };
  crabstodon = callPackage ./crabstodon { };
  eontimer = libsForQt5.callPackage ./eontimer { inherit qtsass; };
  datapath-vision = kernelPackages: kernelPackages.callPackage ./datapath-vision { };
  datapath-vision-firmware = callPackage ./datapath-vision-firmware { };
  determination-fonts = callPackage ./determination-fonts { };
  hactoolnet = callPackage ./hactoolnet { };
  hyfetch = callPackage ./hyfetch { };
  mediawiki-extensions = callPackage ./mediawiki-extensions { };
  office-2007-fonts = callPackage ./office-2007-fonts { };
  pam-fprint-grosshack = callPackage ./pam-fprint-grosshack { };
  qtsass = python3.pkgs.toPythonApplication (python3.pkgs.callPackage ./qtsass { });
  redumper = callPackage ./redumper { };
  reposilite = callPackage ./reposilite { };
  rust = callPackage ./rust { };
  sddm-theme-breeze-user = kdePackages.callPackage ./sddm-theme-breeze-user { };
  twemoji-ttf = callPackage ./twemoji-ttf { };
  udisks2 = callPackage ./udisks/2-default.nix { };
  vimPlugins = callPackages ./vim-plugins { };
  vxis-capture-fw-mod = callPackage ./vxis-capture-fw-mod { };
}
