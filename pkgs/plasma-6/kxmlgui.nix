{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules, qttools,
  kconfig, kconfigwidgets, kglobalaccel, ki18n, kiconthemes, kitemviews,
  kwindowsystem, kguiaddons, qtbase,
}:

stdenv.mkDerivation rec {
  pname = "kxmlgui";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "1b7c82422ef15b92e3dd5ec4beaf6815303e0630";
    sha256 = "waMlFo2KBIeBGQJoGe3rtZq7UeVLFB6qlrv4TmXJl9w=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kglobalaccel ki18n kiconthemes kitemviews kwindowsystem kguiaddons
  ];
  propagatedBuildInputs = [ kconfig kconfigwidgets qtbase qttools ];
}
