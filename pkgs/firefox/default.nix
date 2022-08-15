{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "104.0b9";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b9/linux-x86_64/en-US/firefox-104.0b9.tar.bz2";
    sha512 = "943207b693d9c17f160185832bc19b041dab6177c266ee81e88f8c4855a7033843256c44af03224584d89028ff60752b3c5136c157350413b96d89e3fd6bf7b2";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b9/linux-x86_64/en-US/firefox-104.0b9.tar.bz2.asc";
    sigSha512 = "5906121035a43903ce9477a194bd85dac405481d12b978b2121c7c8f3e094485dbd6bf23d440fb7d9d4eb1868db600fa4c5b809036470d32fb803acd6207bbf0";
  };
}
