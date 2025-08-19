{
  callPackage,
  callPackages,
  python3,
  kdePackages,
  beetsPackages,
}:

rec {
  ath12k = callPackage ./ath12k { };
  avmvc12 = callPackage ./avmvc12 { };
  beetcamp = callPackage ./beetcamp { beets = beetsPackages.beets-minimal; };
  bin = callPackage ./bin { };
  crabstodon = callPackage ./crabstodon { };
  datapath-vision = kernelPackages: kernelPackages.callPackage ./datapath-vision { };
  datapath-vision-firmware = callPackage ./datapath-vision-firmware { };
  determination-fonts = callPackage ./determination-fonts { };
  hactoolnet = callPackage ./hactoolnet { };
  hyfetch = callPackage ./hyfetch { };
  mediawiki-extensions = callPackage ./mediawiki-extensions { };
  office-2007-fonts = callPackage ./office-2007-fonts { };
  pam-fprint-grosshack = callPackage ./pam-fprint-grosshack { };
  redumper = callPackage ./redumper { };
  reposilite = callPackage ./reposilite { };
  rust = callPackage ./rust { };
  sddm-theme-breeze-user = kdePackages.callPackage ./sddm-theme-breeze-user { };
  twemoji-ttf = callPackage ./twemoji-ttf { };
  udisks2 = callPackage ./udisks/2-default.nix { };
  vimPlugins = callPackages ./vim-plugins { };
  vxis-capture-fw-mod = callPackage ./vxis-capture-fw-mod { };
}
