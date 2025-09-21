{
  vimUtils,
  fetchgit,
  stdenv,
  lib,
}:
vimUtils.buildVimPlugin {
  pname = "jupytext.nvim";
  version = "git-2025-06-15";
  src = fetchgit {
    url = "https://github.com/goerz/jupytext.nvim.git";
    rev = "d7897ba4012c328f2a6bc955f1fe57578ebaceb1";
    sha256 = "07xb18va9y261ql3zvxvy6lz4nwnkq3qalvxn2fvh4dcm38w5nxl";
  };
  meta = {
    homepage = "https://github.com/goerz/jupytext.nvim";
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
