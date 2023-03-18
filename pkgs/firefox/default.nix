{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "112.0b3";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0b3/linux-x86_64/en-US/firefox-112.0b3.tar.bz2";
    sha512 = "a9ac4e0f2d301ef0524e41b12770d809724480871b56c442c4813d195ab3e2e246832029d39f7d52ec2ba367eaf3754a38e7cc5d4062eb802d71bdacc635c281";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0b3/linux-x86_64/en-US/firefox-112.0b3.tar.bz2.asc";
    sigSha512 = "5a033d88d9ef3cb3abf64b0eb55c78ece369796c90c868087164bd6c88ab533eb831a8fcb483d23cde2ffcf4d6c19d83687dd5fed12448f8b516112e0d0b996c";
  };
}
