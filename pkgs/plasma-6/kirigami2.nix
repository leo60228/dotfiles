{ stdenv, fetchFromGitLab, lib, extra-cmake-modules, qtbase, qtsvg, qttools }:

stdenv.mkDerivation rec {
  pname = "kirigami2";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = "kirigami";
    rev = "d21d17ea6db1010bde2946632cab0c8a7f570337";
    sha256 = "aDS0ataAkaJ6lT/HRUBG2lKjJ+xEmUotci/FlaUwmCg=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ qtbase qtsvg ];
  outputs = [ "out" "dev" ];
}
