{
  callPackage,
  nodejs_18,
  python3,
  libsForQt5,
  qt6,
}:

rec {
  bin = callPackage ./bin { };
  citra = callPackage ./citra { };
  crabstodon = callPackage ./crabstodon { };
  eontimer = libsForQt5.callPackage ./eontimer { inherit qtsass; };
  datapath-vision = kernelPackages: kernelPackages.callPackage ./datapath-vision { };
  datapath-vision-firmware = callPackage ./datapath-vision-firmware { };
  discord = callPackage ./discord { };
  mastodon = callPackage ./mastodon { };
  qtsass = python3.pkgs.toPythonApplication (python3.pkgs.callPackage ./qtsass { });
  reposilite = callPackage ./reposilite { };
  rust = callPackage ./rust { };
  twemoji-colr = callPackage ./twemoji-colr { };
  twemoji-svg = callPackage ./twemoji-svg { };
  vscode-fhs = callPackage ./vscode-fhs { };
  vxis-capture-fw-mod = callPackage ./vxis-capture-fw-mod { };
}
