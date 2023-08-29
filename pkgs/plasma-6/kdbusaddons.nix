{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  qtbase, qttools
}:

stdenv.mkDerivation rec {
  pname = "kdbusaddons";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "378b93699258b31bfd6a878ad69f472745f5cf2d";
    sha256 = "j3PLdkTTDNBCVpb0eC2P5FZwNH3sgWDEQXbAOAeJ4mY=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
}
