{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "vimspector";
  version = "git-2022-11-14";
  src = fetchgit {
    url = "https://github.com/puremourning/vimspector.git";
    rev = "56f469c787c16bf3e57ab27d2d2b3f97064e7686";
    sha256 = "0i6g0flnnby189c1vbkam214ax76kpw5w0w6m326lpakqv4zbvp8";
  };
  postPatch = "rm Makefile";
  meta = {
    homepage = https://github.com/puremourning/vimspector;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
