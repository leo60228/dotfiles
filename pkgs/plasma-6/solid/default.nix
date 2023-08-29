{
  lib, fetchFromGitLab, stdenv,
  bison, extra-cmake-modules, flex,
  media-player-info, qtbase, qtdeclarative, qttools
}:

stdenv.mkDerivation rec {
  pname = "solid";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "5b791851a243d30db53d8382c8be8ec0e2639b3b";
    sha256 = "Z5rA1rf5DH90JOcATVE0/JK0WYc/9qDyoPWiRwdYdyA=";
  };

  dontWrapQtApps = true;

  patches = [ ./fix-search-path.patch ];
  nativeBuildInputs = [ bison extra-cmake-modules flex ]
    ++ lib.optionals stdenv.isLinux [ media-player-info ];
  buildInputs = [ qtdeclarative qttools ];
  propagatedBuildInputs = [ qtbase ];
  propagatedUserEnvPkgs = lib.optionals stdenv.isLinux [ media-player-info ];
}
