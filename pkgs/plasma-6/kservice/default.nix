{
  stdenv, fetchFromGitLab, lib,
  bison, extra-cmake-modules, flex,
  kconfig, kcoreaddons, kcrash, kdbusaddons, ki18n, kwindowsystem,
  qtbase, shared-mime-info,
}:

stdenv.mkDerivation rec {
  pname = "kservice";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "c1e589dc3cf803b64febf619b11339dbdd5181a5";
    sha256 = "W8b1MacCDVXB7nTBs3RAYoEQwfF3VgnKEZKO8ZduVws=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedNativeBuildInputs = [ bison flex ];
  buildInputs = [
    kcrash kdbusaddons ki18n kwindowsystem qtbase
  ];
  propagatedBuildInputs = [ kconfig kcoreaddons ];
  propagatedUserEnvPkgs = [ shared-mime-info ]; # for kbuildsycoca5
  patches = [
    ./qdiriterator-follow-symlinks.patch
    ./no-canonicalize-path.patch
  ];
}
