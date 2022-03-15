{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "solarized8";
  version = "git-2021-04-24";
  src = fetchgit {
    url = "https://github.com/lifepillar/vim-solarized8.git";
    rev = "28b81a4263054f9584a98f94cca3e42815d44725";
    sha256 = "0vq0fxsdy0mk2zpbd1drrrxnbd44r39gqzp0s71vh9q4bnww7jds";
  };
  meta = {
    homepage = https://github.com/lifepillar/vim-solarized8;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
