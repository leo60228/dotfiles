{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "ale";
  version = "git-2022-06-16";
  src = fetchgit {
    url = "https://github.com/dense-analysis/ale.git";
    rev = "91e8422d6d67f1b1139b57b8707945ea2531443e";
    sha256 = "0aqk54gr4nnj3ql4j3f5k2f53yi3vvs5fv09da0b2cv29smcbgm8";
  };
  meta = {
    homepage = https://github.com/dense-analysis/ale;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
