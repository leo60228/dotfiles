{ vimUtils, fetchgit, stdenv }:
vimUtils.buildVimPlugin {
  pname = "nvim-treesitter-refactor";
  version = "git-2020-10-07";
  src = fetchgit {
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor.git";
    rev = "1a377fafa30920fa974e68da230161af36bf56fb";
    sha256 = "06vww83i73f4gyp3x0007qqdk06dd2i9v1v9dk12ky9d8r0pmxl6";
  };
  meta = {
    homepage = https://github.com/nvim-treesitter/nvim-treesitter-refactor;
    maintainers = [ stdenv.lib.maintainers.leo60228 ];
  };
}
