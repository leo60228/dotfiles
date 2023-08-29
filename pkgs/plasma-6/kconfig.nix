{ stdenv, fetchFromGitLab, lib, extra-cmake-modules, qtbase, qttools }:

stdenv.mkDerivation rec {
  pname = "kconfig";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "5289fc5c8d486896ef99028c38818b310879d0d0";
    sha256 = "rxNZADhjeITkB1g6jwWvPzYRQwOYgYYAR/bOrC+3h1U=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
}
