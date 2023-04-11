{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "113.0b1";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/113.0b1/linux-x86_64/en-US/firefox-113.0b1.tar.bz2";
    sha512 = "51bb28e42f0fab4e7d07562c354fa900e78c61c4bdf51c2f2db8130b9afe56355f6d6c8face0a39c479772d2b90864719d2dc246344ea3e24b558376403c27f5";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/113.0b1/linux-x86_64/en-US/firefox-113.0b1.tar.bz2.asc";
    sigSha512 = "1078b17a014310c097a5da3e629470cf7d2a8a23e6677fcb1557c48a33976d7bb285d1be025492e04143e75fa4ed37fc4540ec4a8c96c34cd0f6bf0b4eea228f";
  };
}
