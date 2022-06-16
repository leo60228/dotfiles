{ callPackage }:

{
  bin = callPackage ./bin {};
  discord = callPackage ./discord {};
  firefox = callPackage ./firefox {};
  graalvm-ee = callPackage ./graalvm-ee {};
  mastodon = callPackage ./mastodon {};
  multimc = callPackage ./multimc {};
  ping_exporter = callPackage ./ping_exporter {};
  rust = callPackage ./rust {};
  twemoji-colr = callPackage ./twemoji-colr {};
  twemoji-svg = callPackage ./twemoji-svg {};
  unifi = callPackage ./unifi {};
  vscode-fhs = callPackage ./vscode-fhs {};
}
