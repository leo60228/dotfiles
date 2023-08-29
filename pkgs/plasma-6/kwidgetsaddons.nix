{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  qtbase, qttools
}:

stdenv.mkDerivation rec {
  pname = "kwidgetsaddons";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "7b9bd9508338f87a1310b4f9687149aa105ff8fc";
    sha256 = "oYPJG3B60vS5jNBrCI58WTfNsLSrhN53i38vRkO2IEE=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
