{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "solarized8";
  version = "git-2022-05-03";
  src = fetchgit {
    url = "https://github.com/lifepillar/vim-solarized8.git";
    rev = "9f9b7951975012ce51766356c7c28ba56294f9e8";
    sha256 = "1qg9n6c70jyyh38fjs41j9vcj54qmhkkyzna0la7bwsycqfxbs2x";
  };
  meta = {
    homepage = https://github.com/lifepillar/vim-solarized8;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
