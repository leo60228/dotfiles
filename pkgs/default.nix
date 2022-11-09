{ callPackage }:

{
  bin = callPackage ./bin {};
  crabstodon = callPackage ./crabstodon {};
  discord = callPackage ./discord {};
  firefox = callPackage ./firefox {};
  graalvm-ee = callPackage ./graalvm-ee {};
  mastodon = callPackage ./mastodon {};
  multimc = callPackage ./multimc {};
  ping_exporter = callPackage ./ping_exporter {};
  rust = callPackage ./rust {};
  twemoji-colr = callPackage ./twemoji-colr {};
  twemoji-svg = callPackage ./twemoji-svg {};
  vscode-fhs = callPackage ./vscode-fhs {};
}
