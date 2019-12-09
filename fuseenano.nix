{stdenv, fetchFromGitHub}:
stdenv.mkDerivation {
  name = "fusee-nano";
  src = fetchFromGitHub {
    owner = "DavidBuchanan314";
    repo = "fusee-nano";
    rev = "dde24921b215a30216f83fa5f2b9d373f1bd12dc";
    sha256 = "1dgx2vixm0xsky12szlg36dby3i5yhpsqrwd7sgn9243fclaqimk";
  };
  makeFlags = [ "INTERMEZZO=$(out)/share/intermezzo.bin" ];
  installPhase = ''
    mkdir -p $prefix/bin
    mkdir -p $prefix/share
    cp fusee-nano $prefix/bin
    cp -r files/* $prefix/share
  '';
}
