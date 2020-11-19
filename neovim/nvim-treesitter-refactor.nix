{ vimUtils, fetchgit, stdenv }:
vimUtils.buildVimPlugin {
  pname = "nvim-treesitter-refactor";
  version = "git-2020-10-07";
  src = fetchgit {
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor.git";
    rev = "9d4b9daf2f138a5de538ee094bd899591004f8e2";
    sha256 = "0ma5zsl70mi92b9y8nhgkppdiqfjj0bl3gklhjv1c3lg7kny7511";
  };
  meta = {
    homepage = https://github.com/nvim-treesitter/nvim-treesitter-refactor;
    maintainers = [ stdenv.lib.maintainers.leo60228 ];
  };
}
