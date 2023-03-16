{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "112.0b2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0b2/linux-x86_64/en-US/firefox-112.0b2.tar.bz2";
    sha512 = "57293db6c6575a3cf648719cda61040cd47c8d9818e7782aebb7ecd2b47aba3dea72d6855126424ba6e46c6e16d1ef95d7ed35f98971634494500a546f42f59b";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0b2/linux-x86_64/en-US/firefox-112.0b2.tar.bz2.asc";
    sigSha512 = "832f2e268496b3a4ac931ef6d949f7e678968b832b682a53911a1b890621858c9a380ae3d8235baf7405d0044c2950cb02fee0df9e1a1ff11840e571b25744f2";
  };
}
