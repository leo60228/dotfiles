{ callPackage, nodejs_18 }:

{
  bin = callPackage ./bin {};
  crabstodon = callPackage ./crabstodon {};
  discord = callPackage ./discord {};
  firefox = callPackage ./firefox {};
  lemmy-server = callPackage ./lemmy/server.nix {};
  lemmy-ui = callPackage ./lemmy/ui.nix {
    nodejs = nodejs_18;
  };
  mastodon = callPackage ./mastodon {};
  multimc = callPackage ./multimc {};
  ping_exporter = callPackage ./ping_exporter {};
  rust = callPackage ./rust {};
  twemoji-colr = callPackage ./twemoji-colr {};
  twemoji-svg = callPackage ./twemoji-svg {};
  vscode-fhs = callPackage ./vscode-fhs {};
}
