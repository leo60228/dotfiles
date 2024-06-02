{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "poryscript";
  version = "git-2024-06-02";
  src = fetchgit {
    url = "https://gitlab.com/vriska/vim-poryscript.git";
    rev = "8e8325fb12e09d82414e532f2881a730b02a0b89";
    sha256 = "0fmzk6il9rpz1ncwnizll996j5zdx4dgccl0s70i7fvyxq6w413b";
  };
  meta = {
    homepage = https://gitlab.com/vriska/vim-poryscript;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
