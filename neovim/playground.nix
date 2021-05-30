{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "playground";
  version = "git-2020-10-19";
  src = fetchgit {
    url = "https://github.com/nvim-treesitter/playground.git";
    rev = "0cb0a18378db84c4c2bdb38c28e897958d2ec14d";
    sha256 = "1808kwf3ccrjaqxr43l23kfj8s0zijdk0rpriymqk143b29nk52c";
  };
  meta = {
    homepage = https://github.com/nvim-treesitter/playground;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
