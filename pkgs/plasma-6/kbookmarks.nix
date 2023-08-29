{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules, qttools,
  kcodecs, kconfig, kconfigwidgets, kcoreaddons, kiconthemes, kwidgetsaddons,
  kxmlgui, qtbase,
}:

stdenv.mkDerivation rec {
  pname = "kbookmarks";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "fea5d58f1e40043a285adf6b8604f5170d693a32";
    sha256 = "3iw7F/k6fllSxNlpiW1fllH0qgLHCxm0m64yaPH3hnM=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [
    kcodecs kconfig kconfigwidgets kcoreaddons kiconthemes kxmlgui
  ];
  propagatedBuildInputs = [ kwidgetsaddons qtbase ];
  outputs = [ "out" "dev" ];
}
