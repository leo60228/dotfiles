{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  libpthreadstubs, libXdmcp,
  qtbase, qttools
}:

stdenv.mkDerivation rec {
  pname = "kwindowsystem";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "84c3e33dc35ee588985237c0d3c6f4b658bc559b";
    sha256 = "kfIO7VlUSzdb7OVJK+T6K+NrvoaYb42/I+xN73vBL3U=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ libpthreadstubs libXdmcp qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
