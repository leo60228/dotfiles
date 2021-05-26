{ vimUtils, lib, fetchgit, stdenv, grammars ? {} }:
vimUtils.buildVimPlugin {
  pname = "nvim-treesitter";
  version = "git";
  src = let prefetch = builtins.fromJSON (builtins.readFile ./nvim-treesitter.json); in fetchgit {
    inherit (prefetch) url rev sha256 fetchSubmodules;
  };
  preInstall = lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: ''
  cp ${v}/parser ./parser/${lib.removePrefix "tree-sitter-" k}.so
  '') grammars);
  meta = {
    homepage = https://github.com/nvim-treesitter/nvim-treesitter;
    maintainers = [ stdenv.lib.maintainers.leo60228 ];
  };
}
