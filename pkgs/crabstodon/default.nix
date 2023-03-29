# TODO: make this an override

{ lib, mastodon, callPackage }:

let src = callPackage ./source.nix {};
in (mastodon.override {
  pname = "crabstodon";
  version = ./version.nix;
  srcOverride = src;
  dependenciesDir = ./.;
}).overrideAttrs (oldAttrs: {
  mastodonModules = oldAttrs.mastodonModules.overrideAttrs (oldAttrs: {
    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      sha256 = lib.fakeSha256;
    };
  });
})
