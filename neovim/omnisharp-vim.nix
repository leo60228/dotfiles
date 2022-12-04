{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "omnisharp-vim";
  version = "git-2022-12-03";
  src = fetchgit {
    url = "https://github.com/OmniSharp/omnisharp-vim.git";
    rev = "0b643d4564207e85d19b94180e6ab2e89e7f9c50";
    sha256 = "0bxh4rijypxs1rahvb5h2fk3w8wjifz92dj1whlgf5srm1mvgdcj";
  };
  meta = {
    homepage = https://github.com/OmniSharp/omnisharp-vim;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
