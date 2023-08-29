{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  qtbase, qttools, shared-mime-info,
  kconfig, kguiaddons, ki18n
}:

stdenv.mkDerivation rec {
  pname = "kcolorscheme";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "8c9f001468c351337dcb6fefc4b9f2246233dcae";
    sha256 = "B3gNkUsQqNDy1s7S9y6EEXCcAzfG+CkWIWtYUpIX1hc=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools shared-mime-info kconfig kguiaddons ki18n ];
  propagatedBuildInputs = [ qtbase ];
}
