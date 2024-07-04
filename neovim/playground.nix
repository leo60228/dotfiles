{
  vimUtils,
  fetchgit,
  stdenv,
  lib,
}:
vimUtils.buildVimPlugin {
  pname = "playground";
  version = "git-2022-11-17";
  src = fetchgit {
    url = "https://github.com/nvim-treesitter/playground.git";
    rev = "1290fdf6f2f0189eb3b4ce8073d3fda6a3658376";
    sha256 = "1yznmc5a32b4bw0c9q0jfkbd77xmi7rmihfr0f44bcgqdxlp8151";
  };
  meta = {
    homepage = "https://github.com/nvim-treesitter/playground";
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
