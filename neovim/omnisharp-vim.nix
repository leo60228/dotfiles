{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "omnisharp-vim";
  version = "git-2022-03-14";
  src = fetchgit {
    url = "https://github.com/OmniSharp/omnisharp-vim.git";
    rev = "dde6493ee4ffe6a8b70deb628c4a08431d77ecd9";
    sha256 = "144lw2iih1ymqla11xmz0zyakd3l4pjq70wfz5i8zh9ac3jps88i";
  };
  meta = {
    homepage = https://github.com/OmniSharp/omnisharp-vim;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
