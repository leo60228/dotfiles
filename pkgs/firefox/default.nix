{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "105.0b5";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b5/linux-x86_64/en-US/firefox-105.0b5.tar.bz2";
    sha512 = "18b8a4a9fc37006f1f451263c471494c9447936bdcba8ac8bd2657644be0de9bcc76068cb28e8917c6e124ba07e629364ca52f6ad64e4aa3b7237ae9b5a7034f";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b5/linux-x86_64/en-US/firefox-105.0b5.tar.bz2.asc";
    sigSha512 = "1f027a3d797f1c078ad7249b3310f09504a37bb7bd0417002970874f27d6bc5991be8bf3bc0ace070f39d1ec024e8299f6ba51816790ed1aad8325970c9c15df";
  };
}
