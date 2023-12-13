{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "arduino";
  version = "git-2023-10-28";
  src = fetchgit {
    url = "https://github.com/stevearc/vim-arduino.git";
    rev = "2ded67cdf09bb07c4805d9e93d478095ed3d8606";
    sha256 = "10drm1dfh48wiwlnpycn277haagpm66mxaa2alx3svayln1hi8pr";
  };
  meta = {
    homepage = https://github.com/stevearc/vim-arduino;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
