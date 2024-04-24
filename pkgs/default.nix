{ callPackage, nodejs_18, python3, libsForQt5, qt6 }:

rec {
  bin = callPackage ./bin {};
  bloom = qt6.callPackage ./bloom {};
  citra = callPackage ./citra {};
  crabstodon = callPackage ./crabstodon {};
  eontimer = libsForQt5.callPackage ./eontimer {
    inherit qtsass;
  };
  datapath-vision = kernelPackages: kernelPackages.callPackage ./datapath-vision {};
  datapath-vision-firmware = callPackage ./datapath-vision-firmware {};
  discord = callPackage ./discord {};
  mastodon = callPackage ./mastodon {};
  ping_exporter = callPackage ./ping_exporter {};
  qtsass = python3.pkgs.toPythonApplication (python3.pkgs.callPackage ./qtsass {});
  rust = callPackage ./rust {};
  twemoji-colr = callPackage ./twemoji-colr {};
  twemoji-svg = callPackage ./twemoji-svg {};
  vscode-fhs = callPackage ./vscode-fhs {};
  vxis-capture-fw-mod = callPackage ./vxis-capture-fw-mod {};
}
