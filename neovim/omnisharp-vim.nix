{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "omnisharp-vim";
  version = "git-2020-11-11";
  src = fetchgit {
    url = "https://github.com/OmniSharp/omnisharp-vim.git";
    rev = "25f486c4c42a712148d06812794753f8291ef17c";
    sha256 = "19l54c19pf62wf9h7hx114zd6cqmygr0mc8xjv8315064f8pv12x";
  };
  meta = {
    homepage = https://github.com/OmniSharp/omnisharp-vim; 
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
