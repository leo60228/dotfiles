{ stdenv, lib, fetchFromGitHub, cmake, libusb1, hidapi, yaml-cpp, procps, php, qtbase, qtsvg, qttools, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "bloom";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bloombloombloom";
    repo = "Bloom";
    rev = "v${version}";
    sha256 = "ZZfclZwxsCgApUII79bJVyT5V/dF9jm7l8ynRWCh0UU=";
  };

  nativeBuildInputs = [ cmake (php.withExtensions ({ enabled, all }: enabled ++ [ all.xml ])) qttools wrapQtAppsHook ];
  buildInputs = [ libusb1 hidapi yaml-cpp procps qtbase qtsvg ];

  postPatch = ''
  substituteInPlace cmake/Installing.cmake --replace "/usr/lib/udev/rules.d" "./lib/udev/rules.d"
  '';
}
