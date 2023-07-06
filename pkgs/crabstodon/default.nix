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
      sha256 = "sha256-8fUJ1RBQZ16R3IpA/JEcn+PO04ApQ9TkHuYKycvV8BY=";
    };
  });
})
