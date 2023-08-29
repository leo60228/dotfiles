{ stdenv
, lib
, fetchFromGitLab
, extra-cmake-modules
, kcmutils
, kconfig
, kcoreaddons
, kcolorscheme
, kguiaddons
, ki18n
, kwindowsystem
, kiconthemes
, kirigami2
, qtdeclarative
, fftw
}:

stdenv.mkDerivation {
  pname = "breeze-qt6";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "breeze";
    rev = "953c6b03ee12a1cb82f8e0b30ac1e4101338480f";
    sha256 = "hRcOUBj/6RDY/WzBsTSXBO36H4of8nPIzV3Y3kD55Cg=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kcmutils
    kconfig
    kcolorscheme
    kcoreaddons
    kguiaddons
    ki18n
    kwindowsystem
    kiconthemes
    kirigami2
    qtdeclarative
    fftw
  ];
  outputs = [ "bin" "dev" "out" ];
  cmakeFlags = [ "-DBUILD_QT5=OFF" "-DWITH_DECORATIONS=OFF" ];
}
