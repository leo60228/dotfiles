{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  kcodecs, kconfig, kwidgetsaddons, qtbase, qttools
}:

stdenv.mkDerivation rec {
  pname = "kcompletion";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "e3d20f77e5182d169ce6d20a3ea89af7c92014d4";
    sha256 = "Xd0JdFAPhn1XimcsJTWs+LSdmVq6jb61wv5uW0gnm20=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcodecs kconfig kwidgetsaddons qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
