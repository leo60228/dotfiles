{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  boost, kconfig, kcoreaddons, kio, kwindowsystem, qtbase, qtdeclarative,
}:

stdenv.mkDerivation rec {
  pname = "kactivities";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "c8f167f5f43efa68e4e727555c19ce5ff995b081";
    sha256 = "eolEXvQisXpd+ZpT1PYDDJJatf2oiKKZEu5X9FUhqoc=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    boost kconfig kcoreaddons kio kwindowsystem qtdeclarative
  ];
  propagatedBuildInputs = [ qtbase ];
}
