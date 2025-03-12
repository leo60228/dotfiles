{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeSetupHook,
  writeShellScript,
  php,
  pname,
  src,
  vendorHash,
  composerLock,
  branch,
}:

let
  wrapComposerPackage =
    makeSetupHook
      {
        name = "wrapComposerPackage";
      }
      (
        writeShellScript "wrap-composer-package" ''
          # this will break if an extension includes a folder called "share"...
          linkRepoFiles () {
            find -L $out/share/php/$pname -maxdepth 1 -print0 | while read -d $'\0' f; do
              ln -s "$f" $out/$(basename "$f")
            done
          }
          postFixupHooks+=(linkRepoFiles)
        ''
      );
in
php.buildComposerProject (finalAttrs: rec {
  inherit
    pname
    src
    vendorHash
    composerLock
    ;

  # this is to prevent nix-update from changing it
  version = "0." + "0.1";

  # maybe this should be a per-extension thing
  preBuild = ''
    composer config --no-plugins allow-plugins.composer/installers true 
  '';

  nativeBuildInputs = [ wrapComposerPackage ];

  passthru.preferredBranch =
    if branch != null then
      branch
    else if src ? branch then
      src.branch
    else
      throw "${pname} needs a branch!";

  composerNoDev = true;
  composerNoPlugins = false;
  composerNoScripts = false;
  composerStrictValidation = false;
})
