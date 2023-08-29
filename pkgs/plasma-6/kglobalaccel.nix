{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  kconfig, kcoreaddons, kcrash, kdbusaddons, kservice, kwindowsystem,
  qtbase, qttools, libXdmcp,
}:

stdenv.mkDerivation rec {
  pname = "kglobalaccel";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "b03f4c72c5e4d5b71941f55cc6a5243b4612206a";
    sha256 = "+cRdTFTN9woVz1z8hXbjJcWyXwhIUSEEpAcg5//TjxU=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcoreaddons kcrash kdbusaddons kservice kwindowsystem qttools
    libXdmcp
  ];
  outputs = [ "out" "dev" ];
  propagatedBuildInputs = [ qtbase ];
}
