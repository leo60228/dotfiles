{ vimUtils, fetchgit, stdenv }:
vimUtils.buildVimPlugin {
  name = "ale-git-2020-11-14";
  patches = [ ../files/ale-codefix-hack.diff ];
  src = fetchgit {
    url = "https://github.com/dense-analysis/ale.git";
    rev = "48fe0dd4f629bb1282277ba8a6757a84c13a4dda";
    sha256 = "100lqxxrh34s9a9wgdnd1b419zfsn0bba1z9im07sbbp80acc5l7";
  };
  meta = {
    homepage = https://github.com/dense-analysis/ale; 
    maintainers = [ stdenv.lib.maintainers.leo60228 ];
  };
}
