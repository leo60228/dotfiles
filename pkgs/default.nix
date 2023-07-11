{ callPackage, nodejs_18, python3, libsForQt5 }:

rec {
  bin = callPackage ./bin {};
  crabstodon = callPackage ./crabstodon {};
  eontimer = libsForQt5.callPackage ./eontimer {
    inherit qtsass;
  };
  discord = callPackage ./discord {};
  firefox = callPackage ./firefox {};
  lemmy-server = callPackage ./lemmy/server.nix {};
  lemmy-ui = callPackage ./lemmy/ui.nix {
    nodejs = nodejs_18;
  };
  mastodon = callPackage ./mastodon {};
  multimc = callPackage ./multimc {};
  ping_exporter = callPackage ./ping_exporter {};
  qtsass = python3.pkgs.toPythonApplication (python3.pkgs.callPackage ./qtsass {});
  rust = callPackage ./rust {};
  twemoji-colr = callPackage ./twemoji-colr {};
  twemoji-svg = callPackage ./twemoji-svg {};
  vscode-fhs = callPackage ./vscode-fhs {};
  vxis-capture-fw-mod = callPackage ./vxis-capture-fw-mod {};
}
