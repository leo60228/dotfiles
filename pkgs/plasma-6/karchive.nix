{
  stdenv, fetchFromGitLab, lib,
  extra-cmake-modules,
  bzip2, xz, qtbase, qttools, zlib, zstd
}:

stdenv.mkDerivation rec {
  pname = "karchive";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "ae38aaea31fcb53fde90c20b89a899712b4e9f55";
    sha256 = "hF9dx3aoMzHjXpeTCbfshcOTJlCPnzTrbovcVmV4XR8=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ bzip2 xz zlib zstd ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
