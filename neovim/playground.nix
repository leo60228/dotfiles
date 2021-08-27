{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "playground";
  version = "git-2021-07-27";
  src = fetchgit {
    url = "https://github.com/nvim-treesitter/playground.git";
    rev = "deb887b3f49d66654d9faa9778e8949fe0d80bc3";
    sha256 = "10jlgsqkplisa1fd7i36yb46fdsa0cx069bpwp2yl4ki2jys953j";
  };
  meta = {
    homepage = https://github.com/nvim-treesitter/playground;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
