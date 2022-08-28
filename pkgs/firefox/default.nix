{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "105.0b3";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b3/linux-x86_64/en-US/firefox-105.0b3.tar.bz2";
    sha512 = "cb9a5e3b811bf55946ccb7891b04356bea94df027ade627bf6233f05103a565d050b27c43105a0be83b60bbc804f5adb5866357ece13d38bf7cc7365bbd72e23";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b3/linux-x86_64/en-US/firefox-105.0b3.tar.bz2.asc";
    sigSha512 = "7d877320fd32357057ae829815549682b4487973dc8aa022da811bdcb7fe30fe9fe7c7659455dde70f68323495359902f8324aa5cd2b7455c315e733c6c4b363";
  };
}
