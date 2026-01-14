{
  callPackage,
  callPackages,
  python3,
  kdePackages,
}:

{
  avmvc12 = callPackage ./avmvc12 { };
  beetcamp = python3.pkgs.callPackage ./beetcamp { };
  bin = callPackage ./bin { };
  crabstodon = callPackage ./crabstodon { };
  determination-fonts = callPackage ./determination-fonts { };
  filehost-elixire = callPackage ./filehost-elixire { };
  hactoolnet = callPackage ./hactoolnet { };
  hyfetch = callPackage ./hyfetch { };
  mediawiki-extensions = callPackage ./mediawiki-extensions { };
  office-2007-fonts = callPackage ./office-2007-fonts { };
  pam-fprint-grosshack = callPackage ./pam-fprint-grosshack { };
  reposilite = callPackage ./reposilite { };
  rust = callPackage ./rust { };
  sddm-theme-breeze-user = kdePackages.callPackage ./sddm-theme-breeze-user { };
  twemoji-ttf = callPackage ./twemoji-ttf { };
  udisks2 = callPackage ./udisks/2-default.nix { };
  vimPlugins = callPackages ./vim-plugins { };
  vxis-capture-fw-mod = callPackage ./vxis-capture-fw-mod { };
}
