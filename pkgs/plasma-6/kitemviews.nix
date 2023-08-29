{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  qtbase, qttools
}:

stdenv.mkDerivation rec {
  pname = "kitemviews";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "7ed358dd0ebcb8ca94ec615f1ef2704d70fb58b6";
    sha256 = "FdgcECmVhfZP9aQxiLq73Ttd/yVYjJe/evL1pktYKBs=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
