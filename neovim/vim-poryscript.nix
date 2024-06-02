{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "poryscript";
  version = "git-2024-06-01";
  src = fetchgit {
    url = "https://gitlab.com/vriska/vim-poryscript.git";
    rev = "15906beb7e5e34e39644ab1ff5905d72e6a58d6a";
    sha256 = "13cir82y9f5racdyaqbcj5n2bqzzi3rxisajr0h95siig4vf3gri";
  };
  meta = {
    homepage = https://gitlab.com/vriska/vim-poryscript;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
