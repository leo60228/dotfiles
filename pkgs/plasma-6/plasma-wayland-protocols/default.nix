{ stdenv
, fetchFromGitLab
, lib
, extra-cmake-modules
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = pname;
    rev = "6e08d9c981278660791e72fec06d143403a98ba2";
    sha256 = "j7ITtjeh3HryJEwrV+X34sznzBQlLVYCM++6l6FcUok=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ qtbase ];

  meta = {
    description = "Plasma Wayland Protocols";
    license = lib.licenses.lgpl21Plus;
    platforms = qtbase.meta.platforms;
  };
}
