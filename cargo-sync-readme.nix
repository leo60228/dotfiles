{ naersk, fetchFromGitHub }:
naersk.buildPackage {
  src = fetchFromGitHub {
    owner = "phaazon";
    repo = "cargo-sync-readme";
    rev = "1.0";
    sha256 = "1c38q87fyfmj6nlwdpavb1xxpi26ncywkgqcwbvblad15c6ydcyc";
  };
}
