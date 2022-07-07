{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "103.0b5";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b5/linux-x86_64/en-US/firefox-103.0b5.tar.bz2";
    sha512 = "a6df09804d543bc44dfc7ca763463406df47aa2849f5d8ea41782cdf8e888f5f1c98541fb78e5e0cec948d9f7db5ffa4e398968d7dea18ba201d48b316792482";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b5/linux-x86_64/en-US/firefox-103.0b5.tar.bz2.asc";
    sigSha512 = "fb07f1b7f4a4ef7171b989e9f183d61da7bf3ff79098eac2c3c3842ad5bdaf0dfc459ab192ef0cc3b312d588b4344b91dc53a046475f3d00fa9b82854ff6e122";
  };
}
