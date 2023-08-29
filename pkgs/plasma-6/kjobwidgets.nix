{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules, qttools,
  kcoreaddons, kwidgetsaddons, knotifications
}:

stdenv.mkDerivation rec {
  pname = "kjobwidgets";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "5c70d9bffa56a22944d90650e15734752731ed61";
    sha256 = "rX6mQbbTqGS4UUe91Ev1hrC/pp+ODvKqx9yzmcEsdvE=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ kcoreaddons kwidgetsaddons knotifications ];
}
