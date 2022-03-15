{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "nvim-treesitter-refactor";
  version = "git-2022-01-22";
  src = fetchgit {
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor.git";
    rev = "0dc8069641226904f9757de786a6ab2273eb73ea";
    sha256 = "193fk657wjxz7hfbkjw566bng62vv7432cjhb5rwcig04xd5izqm";
  };
  meta = {
    homepage = https://github.com/nvim-treesitter/nvim-treesitter-refactor;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
