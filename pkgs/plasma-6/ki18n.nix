{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules, gettext, python3,
  qtbase, qtdeclarative,
}:

stdenv.mkDerivation rec {
  pname = "ki18n";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "cbf65b94fcbc21852b48ae65dd260f0d614e6818";
    sha256 = "fezoWSvCWQUz/XLkJTMSvVe+/sQy8FkWf2YhLWKzbQw=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedNativeBuildInputs = [ gettext python3 ];
  buildInputs = [ qtdeclarative ];
}
