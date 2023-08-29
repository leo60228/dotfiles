{ fetchFromGitLab, lib, stdenv
, extra-cmake-modules
, kcodecs, kconfig, kcoreaddons, kwindowsystem
, libcanberra
, qttools
}:

stdenv.mkDerivation rec {
  pname = "knotifications";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "779e0dc3b0302fd708e27cf35f9c5fcc75f39657";
    sha256 = "wC9A02sCIU93DCky6ZDRO5zwqPhwbw7qkJetmZsGO3U=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [
    kcodecs kconfig kcoreaddons kwindowsystem libcanberra
  ];
}
