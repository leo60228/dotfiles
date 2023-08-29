{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  breeze-icons, karchive, kcoreaddons, kconfigwidgets, ki18n, kwidgetsaddons, kcolorscheme,
  qtbase, qtsvg, qttools,
}:

stdenv.mkDerivation rec {
  pname = "kiconthemes";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "89013104b13b8947da0a5407d40cdbccdc82852a";
    sha256 = "qGNAnwFClGjFAriOuM/Ekq0ciukhmYTgl8d3aAueQUk=";
  };

  dontWrapQtApps = true;

  patches = [
    ./default-theme-breeze.patch
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    breeze-icons karchive kcoreaddons kconfigwidgets ki18n kwidgetsaddons kcolorscheme
  ];
  propagatedBuildInputs = [ qtbase qtsvg qttools ];
}
