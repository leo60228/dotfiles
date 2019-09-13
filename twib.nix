{ stdenv, fetchFromGitHub, cmake, pkgconfig, libusb1 }:
stdenv.mkDerivation rec {
  name = "twib";
  src = fetchFromGitHub {
    owner = "misson20000";
    repo = "twili";
    rev = "683972eb0bb7c000570fd639e64eb06b761b0aa2";
    sha256 = "11ammi5dz1mmxavj5fpfkw9ad9x2vkav70w7jz669im7baj5f0d3";
    fetchSubmodules = true;
  };
  preConfigure = "cd twib";
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libusb1 ];
  cmakeFlags = [ "-DWITH_SYSTEMD=ON" ];
}
