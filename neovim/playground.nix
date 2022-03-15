{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "playground";
  version = "git-2022-02-16";
  src = fetchgit {
    url = "https://github.com/nvim-treesitter/playground.git";
    rev = "9df82a27a49e1c14e9d7416b537517a79d675086";
    sha256 = "1hhrcsrgcy3vqxn9gsm68r77n6z5bw4cr0r47darffan5rxykz21";
  };
  meta = {
    homepage = https://github.com/nvim-treesitter/playground;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
