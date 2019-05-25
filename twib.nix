{ stdenv, fetchFromGitHub, cmake, pkgconfig, libusb1 }:
stdenv.mkDerivation rec {
  name = "twib";
  src = fetchFromGitHub {
    owner = "misson20000";
    repo = "twili";
    rev = "91580b9f12e7c1246ac35d2b817d5b0e0a3ee85f";
    sha256 = "1l9zs81n6wh0hdhsy0ylfskjhhypmg5dqq5v8gr2vfzfsz9nkwcl";
    fetchSubmodules = true;
  };
  preConfigure = "cd twib";
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libusb1 ];
  cmakeFlags = [ "-DWITH_SYSTEMD=ON" ];
}
