{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "nvim-treesitter-refactor";
  version = "git-2022-05-14";
  src = fetchgit {
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor.git";
    rev = "75f5895cc662d61eb919da8050b7a0124400d589";
    sha256 = "1wpszy4mga9piq5c5ywgdw15wvff8l8a7a6agygfv1rahfv3087j";
  };
  meta = {
    homepage = https://github.com/nvim-treesitter/nvim-treesitter-refactor;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
