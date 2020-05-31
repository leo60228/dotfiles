{ vimUtils, fetchFromGitHub, stdenv }:
vimUtils.buildVimPlugin {
  pname = "graphql";
  version = "2020-03-30";
  src = fetchFromGitHub {
    owner = "jparise";
    repo = "vim-graphql";
    rev = "a3ff39f955e60baeddd8c3c4d1cab291ce37d66e";
    sha256 = "0d98b0zpbyjcafp0q25c3qsx13q74nszxsi5jxxjnpz1wv6s83x1";
  };
  meta.homepage = "https://github.com/jparise/vim-graphql/";
}
