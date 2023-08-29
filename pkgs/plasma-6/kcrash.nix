{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  kcoreaddons, kwindowsystem, qtbase
}:

stdenv.mkDerivation rec {
  pname = "kcrash";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "198df4ed8fbc0e630a53e3fbd385bbcbbbe9ea48";
    sha256 = "GqLgnyDO+KWUqOmAeG8SiMn8XvSGrH3Thti0xvgVSUM=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons kwindowsystem ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
