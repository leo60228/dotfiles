{ stdenv, fetchFromGitHub, cmake, pkgconfig, libusb1 }:
stdenv.mkDerivation rec {
  name = "twib";
  src = fetchFromGitHub {
    owner = "misson20000";
    repo = "twili";
    rev = "c88a0930cdfd8715223f6d912cbab1b56188532e";
    sha256 = "02ypicdpc5m9k1vdh1vppxd2slws5j571x0q1qfygappv7yrjx0a";
    fetchSubmodules = true;
  };
  preConfigure = "cd twib";
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libusb1 ];
  cmakeFlags = [ "-DWITH_SYSTEMD=ON" ];
}
