{ lib, mastodon, callPackage, fetchYarnDeps }:

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
      sha256 = "sha256-WsPNqV1PC2YjL37qnWfRTj8LaIBUI7+C0cWTfFd7HGo=";
    };
  });
})
