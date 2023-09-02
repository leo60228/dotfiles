{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "117.0";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/117.0/linux-x86_64/en-US/firefox-117.0.tar.bz2";
    sha512 = "737bb26a12ab8cda7ba56b30a75d77f4c7e228f958ba4970704cfbb01621e185723a32ab038424b7893926de8d77b1b247ce7a6f02cdc1fd87ff846080e2849e";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/117.0/linux-x86_64/en-US/firefox-117.0.tar.bz2.asc";
    sigSha512 = "ac02cf07532167b93afc13b0358fa667c4ff6feb565adde4e9b1e813fe278c8a228a54c1f2545e73099d28bd66420f4cfe9ca819cd4eb03cfcd5f47e3571fb4f";
  };
}
