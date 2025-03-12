# https://github.com/ihaveamac/nix-config/blob/main/nixos-tataru/func-get-wm-extension.nix
{ fetchFromGitHub }:

{
  name,
  rev,
  hash,
  branch ? null,
  skin ? false,
}:
let
  mediawiki-info = builtins.fromJSON (builtins.readFile ./mediawiki-info.json);
  defaultBranch = "REL1_43";
  ext = fetchFromGitHub rec {
    inherit rev hash;
    owner = "wikimedia";
    repo = "mediawiki-${if skin then "skins" else "extensions"}-${name}";
    passthru = {
      # this should be provided by default, but is not for some reason
      gitRepoUrl = "https://github.com/${owner}/${repo}.git";
      branch = if branch == null then defaultBranch else branch;
      # this is kind of a hack
      src = ext;
      # this is also kind of a hack (prevent nix-update from updating the useless version)
      version = "0" + "0";
    };
  };
in
ext
