{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "solarized8";
  version = "git-2019-05-02";
  src = fetchgit {
    url = "https://github.com/lifepillar/vim-solarized8.git";
    rev = "30fd9196e0ae330a33ca00e255c8392516bc242c";
    sha256 = "1rc6ldh7c5w5sy9xa4lbz0j28jainqfvdlfni7qc5s2wdc4i1jy9";
  };
  meta = {
    homepage = https://github.com/lifepillar/vim-solarized8;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
