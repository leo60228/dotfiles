# nix-instantiate --eval --strict --json get-composer-ext-info.nix | jq
{ extname }:
let
  exts = (import <nixpkgs> { }).callPackage ./. { };
  ext = exts.${extname};
in
{
  composerLock = toString ext.composerLock;
  gitRepoUrl = ext.src.gitRepoUrl;
  currentRev = ext.src.rev;
  # this should now always be default.nix
  #fileWithSrc = (builtins.unsafeGetAttrPos "src" ext).file;
  preferredBranch = ext.passthru.preferredBranch or null;
}
