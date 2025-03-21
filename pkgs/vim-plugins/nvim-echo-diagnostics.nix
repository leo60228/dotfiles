{
  vimUtils,
  fetchgit,
  stdenv,
  lib,
}:
vimUtils.buildVimPlugin {
  pname = "nvim-echo-diagnostics";
  version = "git-2022-03-08";
  src = fetchgit {
    url = "https://github.com/seblj/nvim-echo-diagnostics.git";
    rev = "a8f82151b1789e532253f4a6155dd2dac4653a81";
    sha256 = "16vr1i12kv9n07533faacm05sikx4wkj1xwj8xg23r22n4an7xd6";
  };
  meta = {
    homepage = "https://github.com/seblj/nvim-echo-diagnostics";
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
