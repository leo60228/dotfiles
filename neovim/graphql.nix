{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = "graphql";
  version = "git-2022-06-05";
  src = fetchgit {
    url = "https://github.com/jparise/vim-graphql.git";
    rev = "4bf5d33bda83117537aa3c117dee5b9b14fc9333";
    sha256 = "1pai8zdzn89yk6b4jcvw5yk074sw2qzf9dsw4gbsf69avjkbhx90";
  };
  postPatch = "rm Makefile";
  meta = {
    homepage = https://github.com/jparise/vim-graphql;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
