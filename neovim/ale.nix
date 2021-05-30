{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "ale";
  version = "git-2021-02-02";
  src = fetchgit {
    url = "https://github.com/dense-analysis/ale.git";
    rev = "9b5c09047361f3ec2cf18afbb6d1e03047a59778";
    sha256 = "043jbgqw3m8bqsp1piamwgmsqg3136fhksagb157zppxbw25jkgd";
  };
  meta = {
    homepage = https://github.com/dense-analysis/ale;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
