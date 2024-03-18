{ lib
, stdenv
, fetchFromGitHub
, cmake
, liboqs
, openssl
}:

stdenv.mkDerivation rec {
  pname = "oqs-provider";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = pname;
    rev = version;
    hash = "sha256-Uh7tMJefB2XumAgEIB8jGDVa/DEmk2BIBYikw4UqdX0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ liboqs openssl ];

  postPatch = ''
  substituteInPlace CMakeLists.txt --replace "{OPENSSL_LIB_DIR}" "{CMAKE_INSTALL_PREFIX}/lib"
  '';
}
