# stolen from https://git.catgirl.cloud/999eagle/dotfiles-nix
{
  callPackage,
  patches ? [],
  srcPostPatch ? "",
  mastodon,
}: let
  src = callPackage ./source.nix {
    inherit patches;
    postPatch = srcPostPatch;
  };

  # the upstream nix package doesn't support yarn berry yet so here we fucking go
  # see https://github.com/NixOS/nixpkgs/issues/254369 and https://github.com/NixOS/nixpkgs/issues/277697
  yarn-deps = callPackage ./yarn.nix {
    inherit src;
    hash = src.yarnHash;
  };

  # this is mastodon built from the glitch source
  # modules are unpatched though
  glitch-1 = mastodon.override {
    pname = "glitch";
    srcOverride = src;
    gemset = ./. + "/gemset.nix";
  };

  modules = callPackage ./modules.nix {
    inherit glitch-1 yarn-deps;
  };

  glitch-2 = glitch-1.overrideAttrs (old: {
    mastodonModules = modules;
  });
in
  glitch-2
