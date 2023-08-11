{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "116.0.2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/116.0.2/linux-x86_64/en-US/firefox-116.0.2.tar.bz2";
    sha512 = "c0ec83a8d5184266680aee6de281169691e4d4089645d3eab534ccf84e6a46f4f283267cc74f119c6a2340c0234db197bbae47aa36483cff9a48746f9f0f8473";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/116.0.2/linux-x86_64/en-US/firefox-116.0.2.tar.bz2.asc";
    sigSha512 = "1dbb1e0ff667fffd40633171335ff5a97b1e1264cc8a69c01c47e9b34c0d8209ff55a5b32c930fa57b22c525ac799882e51c519775998ec41552d6f8fe2d53d1";
  };
}
