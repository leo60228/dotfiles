{ stdenv, pkgconfig, gtk3, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "opensnap";
  version = "git";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 ];

  src = fetchFromGitHub {
    owner = "lawl";
    repo = "opensnap";
    rev = "20583419b6bc746becf3f1059b9249e11c7fb313";
    sha256 = "0hyz88gzg29nwralx2qgs61h2bm7w7bqq9sgjxb7vkz9jmszh8wd";
  };

  installPhase = ''
  mkdir -p $out/bin
  cp ./bin/opensnap $out/bin/
  '';
}
