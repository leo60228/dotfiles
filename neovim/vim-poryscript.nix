{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "poryscript";
  version = "git-2024-06-01";
  src = fetchgit {
    url = "https://gitlab.com/vriska/vim-poryscript.git";
    rev = "4982afa11afc6102d8c5d9d002249851771d35f8";
    sha256 = "1x3nkp7lzlsv7bin98xkcsvj055rxp9qlpd2wn8zk0b4fnxp73dg";
  };
  meta = {
    homepage = https://gitlab.com/vriska/vim-poryscript;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
