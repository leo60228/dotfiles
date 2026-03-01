{
  callPackage,
  callPackages,
  python3,
  kdePackages,
}:

{
  amdgpu-hdmi-frl = callPackage ./amdgpu-hdmi-frl { };
  avmvc12 = callPackage ./avmvc12 { };
  beetcamp = python3.pkgs.callPackage ./beetcamp { };
  bin = callPackage ./bin { };
  crabstodon = callPackage ./crabstodon { };
  determination-fonts = callPackage ./determination-fonts { };
  evdev-keepalive = callPackage ./evdev-keepalive { };
  filehost-elixire = callPackage ./filehost-elixire { };
  hactoolnet = callPackage ./hactoolnet { };
  hyfetch = callPackage ./hyfetch { };
  mediawiki-extensions = callPackage ./mediawiki-extensions { };
  ms-fonts = callPackage ./ms-fonts { };
  pam-fprint-grosshack = callPackage ./pam-fprint-grosshack { };
  reposilite = callPackage ./reposilite { };
  rust = callPackage ./rust { };
  sddm-theme-breeze-user = kdePackages.callPackage ./sddm-theme-breeze-user { };
  twemoji-ttf = callPackage ./twemoji-ttf { };
  udisks2 = callPackage ./udisks/2-default.nix { };
  vimPlugins = callPackages ./vim-plugins { };
  vxis-capture-fw-mod = callPackage ./vxis-capture-fw-mod { };
}
