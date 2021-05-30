{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "vimspector";
  version = "git-2020-11-16";
  src = fetchgit {
    url = "https://github.com/puremourning/vimspector.git";
    rev = "888c558aa4386710bd3a53ac4bed592993c5a9f3";
    sha256 = "1cxib3m4n7kyr1bzb1ac1whdqrpzqs7gyygkxmd3j9np76z9ki00";
  };
  meta = {
    homepage = https://github.com/puremourning/vimspector;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
