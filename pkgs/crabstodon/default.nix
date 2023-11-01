{ lib, mastodon, callPackage, fetchYarnDeps }:

let src = callPackage ./source.nix {};
in mastodon.override {
  pname = "crabstodon";
  version = import ./version.nix;
  srcOverride = src;
  gemset = ./. + "/gemset.nix";
  yarnHash = "sha256-WsPNqV1PC2YjL37qnWfRTj8LaIBUI7+C0cWTfFd7HGo=";
}
