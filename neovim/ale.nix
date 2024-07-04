{
  vimUtils,
  fetchgit,
  stdenv,
  lib,
}:
vimUtils.buildVimPlugin {
  pname = "ale";
  version = "git-2022-11-25";
  src = fetchgit {
    url = "https://github.com/dense-analysis/ale.git";
    rev = "5ce2bf84ca00cee8f375f108952789302980ae57";
    sha256 = "0xjkhh4y78zcnw1xm0zhwvxamk85qqnpvj8ik2r1hp9vxq71b7n0";
  };
  meta = {
    homepage = "https://github.com/dense-analysis/ale";
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
