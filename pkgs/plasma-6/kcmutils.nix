{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  kactivities, kio, kconfigwidgets, kcoreaddons, ki18n, kitemviews,
  kwidgetsaddons, kxmlgui, kguiaddons, kbookmarks, kcompletion, kjobwidgets, kwindowsystem, qtdeclarative,
}:

stdenv.mkDerivation rec {
  pname = "kcmutils";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "5b70865138baf2d86b9d8773b40a7770eab11712";
    sha256 = "KshKWrxcZ4v77cFISrfjKI0ggJ3t+B1yFfjV8imOwpI=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kactivities kio kcoreaddons ki18n kguiaddons kitemviews kxmlgui kwidgetsaddons kbookmarks kcompletion kjobwidgets kwindowsystem
    qtdeclarative
  ];
  propagatedBuildInputs = [ kconfigwidgets ];
}
