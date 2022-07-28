{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "playground";
  version = "git-2022-06-22";
  src = fetchgit {
    url = "https://github.com/nvim-treesitter/playground.git";
    rev = "ce7e4b757598f1c785ed0fd94fc65959acd7d39c";
    sha256 = "0r3pjpzwjp1m563n80qp93y7f8gvpqjzlhsrd0hvi67qzm6pj87f";
  };
  meta = {
    homepage = https://github.com/nvim-treesitter/playground;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
