{
  stdenv, lib, fetchFromGitLab, fetchpatch,
  extra-cmake-modules, qttools,
  acl, attr, libkrb5, util-linux,
  karchive, kconfig, kcoreaddons,
  kdbusaddons, ki18n,
  kservice, kauth,
  kbookmarks, kcolorscheme, kcompletion, kconfigwidgets, kguiaddons,
  kiconthemes, kitemviews, kjobwidgets, kwidgetsaddons, kwindowsystem,
  qtbase, qt5compat, solid, kcrash
}:

stdenv.mkDerivation rec {
  pname = "kio";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "8b515e3827fa464384ae142cce493e9a97351c5b";
    sha256 = "hPsan6y8DcNdYYtxf/rIat8q1Zcxoi85lUD9TaUGrzk=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    karchive kdbusaddons ki18n kauth
    kcrash libkrb5
    kbookmarks kcolorscheme kcompletion kconfigwidgets kguiaddons
    kiconthemes kitemviews kjobwidgets kwidgetsaddons kwindowsystem
  ] ++ lib.lists.optionals stdenv.isLinux [
    acl attr # both are needed for ACL support
    util-linux # provides libmount
  ];
  propagatedBuildInputs = [
    kconfig kcoreaddons kservice
    qtbase qt5compat qttools solid
  ];
  outputs = [ "out" "dev" ];
}
