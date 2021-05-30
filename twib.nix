{ stdenv, fetchFromGitHub, cmake, pkgconfig, libusb1 }:
stdenv.mkDerivation rec {
  name = "twib";
  src = fetchFromGitHub {
    owner = "misson20000";
    repo = "twili";
    rev = "947d96e677ee6eec473a0556acbd7d75f13152e3";
    sha256 = "7IzeEe+nxSsbAO9pq+5K91tP9QS9+vcxb87Y/sSOZnc=";
    fetchSubmodules = true;
  };
  preConfigure = "cd twib";
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libusb1 ];
  cmakeFlags = [ "-DWITH_SYSTEMD=ON" ];
}
