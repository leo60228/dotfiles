{ stdenv, fetchFromGitLab, lib
, extra-cmake-modules
, qtbase, qtwayland, wayland, plasma-wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "kguiaddons";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "c5ed05d6391f22eaeffb2c072293ef988dde0dc6";
    sha256 = "3iJ5rNWtnRZhcQWBPvTEz4koZE1vVOOCllyw8jmeLBo=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtwayland wayland plasma-wayland-protocols ];
  propagatedBuildInputs = [ qtbase ];

  outputs = [ "out" "dev" ];

  meta.homepage = "https://invent.kde.org/frameworks/kguiaddons";
}
