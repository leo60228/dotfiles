{
  stdenv, fetchFromGitLab, lib, extra-cmake-modules,
  kcoreaddons, kcolorscheme, kcodecs, kconfig, kguiaddons, ki18n, kwidgetsaddons, qttools, qtbase,
}:

stdenv.mkDerivation rec {
  pname = "kconfigwidgets";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "9be3774b9aca01a2dcc4cc0e7bbbb9f1bb934d09";
    sha256 = "VQDzDvv0USOu1q5RJu6m6/wTAaBJ+WcoPZDbwo0mwHE=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kguiaddons ki18n qtbase qttools ];
  propagatedBuildInputs = [ kcoreaddons kcolorscheme kcodecs kconfig kwidgetsaddons ];
  outputs = [ "out" "dev" ];
  outputBin = "dev";
  postInstall = ''
    moveToOutput ''${qtPluginPrefix:?}/designer/kconfigwidgets5widgets.so "$out"
  '';
}
