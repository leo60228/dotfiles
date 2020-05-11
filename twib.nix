{ stdenv, fetchFromGitHub, cmake, pkgconfig, libusb1 }:
stdenv.mkDerivation rec {
  name = "twib";
  src = fetchFromGitHub {
    owner = "misson20000";
    repo = "twili";
    rev = "7a6029c2d583f5b6f741beddfb04f7782b346b1e";
    sha256 = "0az2200g8pvvs8igmjgfa6xakssg0ghzn8nbza4ibngz11zk49al";
    fetchSubmodules = true;
  };
  preConfigure = "cd twib";
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libusb1 ];
  cmakeFlags = [ "-DWITH_SYSTEMD=ON" ];
}
