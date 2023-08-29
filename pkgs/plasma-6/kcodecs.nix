{ stdenv, fetchFromGitLab, lib, extra-cmake-modules, qtbase, qttools, gperf }:

stdenv.mkDerivation rec {
  pname = "kcodecs";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "4db348a5457e4f3df26432fea6b948ac52e6f2f8";
    sha256 = "5yDIHrRrg6hdbKTMEBj6e32x5qc/O72j8GPYJs6t090=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools gperf ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
