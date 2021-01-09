{ vimUtils, fetchgit, stdenv }:
vimUtils.buildVimPlugin {
  pname = "ale";
  version = "git-2020-12-28";
  src = fetchgit {
    url = "https://github.com/dense-analysis/ale.git";
    rev = "7fca451cf9a3068efe5e93fcc4b5494d939245fb";
    sha256 = "1g87lrf5g4alnax982nxfc5aa39mzsmh6zwrzcxhs0zpinm52vlc";
  };
  meta = {
    homepage = https://github.com/dense-analysis/ale;
    maintainers = [ stdenv.lib.maintainers.leo60228 ];
  };
}
