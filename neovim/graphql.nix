{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "graphql";
  version = "git-2022-02-07";
  src = fetchgit {
    url = "https://github.com/jparise/vim-graphql.git";
    rev = "15c5937688490af8dde09e90c9a5585c840ba81c";
    sha256 = "092qzsg97qcd2qmv4fxfd8vjjwl11wrv0m2ag2w77354m6zkizwq";
  };
  postPatch = "rm Makefile";
  meta = {
    homepage = https://github.com/jparise/vim-graphql;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
