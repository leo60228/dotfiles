{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "104.0b2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b2/linux-x86_64/en-US/firefox-104.0b2.tar.bz2";
    sha512 = "4d38d33cfa1362e6eae1f7ae4352b52e088eb67ea81886edc15225d5058877271023195000d286801064892d6a89b264b59c8ae3a550389c0465184ffaf760e2";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b2/linux-x86_64/en-US/firefox-104.0b2.tar.bz2.asc";
    sigSha512 = "2c7416d68b3c396840045ab9a5a45b92f4eaf8c3746f084ad5a6d01c652be8aa66bf7ecc3aafbd7ceb02be1e724dab1acdba139bcecbe5fb0257071e7b947b9e";
  };
}
