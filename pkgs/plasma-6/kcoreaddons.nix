{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  qtbase, qttools, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "kcoreaddons";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "018bf2c7987985fb77a86acef0c4524b6fd969e7";
    sha256 = "8xEIhdkLB2RgDOwQ6p8BBA3Rn/voIQVzsAdiCLjzCXc=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools shared-mime-info ];
  propagatedBuildInputs = [ qtbase ];
}
