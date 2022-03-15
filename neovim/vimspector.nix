{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "vimspector";
  version = "git-2022-03-15";
  src = fetchgit {
    url = "https://github.com/puremourning/vimspector.git";
    rev = "eaaf5f8f394109bd5c6466ea0528412782ba4426";
    sha256 = "0yjx5s9plar8j8023j7fcwbzfppvfpyv9j3kkz29f7pqdca8gghd";
  };
  postPatch = "rm Makefile";
  meta = {
    homepage = https://github.com/puremourning/vimspector;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
