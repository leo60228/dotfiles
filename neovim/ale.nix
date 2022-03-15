{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "ale";
  version = "git-2022-03-05";
  src = fetchgit {
    url = "https://github.com/dense-analysis/ale.git";
    rev = "560e6340ce10ce90fac587096fb147eea43e624d";
    sha256 = "1bkmhqj9hadv9i2zqsnykc7pmql1fxvdd25417g7hxb9ld9n89ca";
  };
  meta = {
    homepage = https://github.com/dense-analysis/ale;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
