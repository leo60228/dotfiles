{ stdenv, fetchFromGitLab, lib, fetchpatch, cmake, pkg-config }:

stdenv.mkDerivation {
  pname = "extra-cmake-modules";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = "extra-cmake-modules";
    rev = "a93943adfe95a48573ab9f62488b7b0352de4eba";
    sha256 = "sha256-3Z8KzsuzHHedUXJGIPa2MVS9ZWoutbiEIr4FM5o7Nqo=";
  };

  patches = [
    # https://invent.kde.org/frameworks/extra-cmake-modules/-/merge_requests/268
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/extra-cmake-modules/-/commit/5862a6f5b5cd7ed5a7ce2af01e44747c36318220.patch";
      sha256 = "10y36fc3hnpmcsmjgfxn1rp4chj5yrhgghj7m8gbmcai1q5jr0xj";
    })
  ];

  outputs = [ "out" ];  # this package has no runtime components

  propagatedBuildInputs = [ cmake pkg-config ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    platforms = platforms.linux ++ platforms.darwin;
    homepage = "https://invent.kde.org/frameworks/extra-cmake-modules";
    license = licenses.bsd2;
  };
}
