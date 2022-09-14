{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "105.0b9";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b9/linux-x86_64/en-US/firefox-105.0b9.tar.bz2";
    sha512 = "b42f78d2aa0ec9197cb01eeefd11c39da3399fcf1759a0217848ec896b19aea34649616b4fd9f63138f54a21059cfe06ba191e32d3495527fe06a5caae384689";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b9/linux-x86_64/en-US/firefox-105.0b9.tar.bz2.asc";
    sigSha512 = "a52d0dee3c74fef32dba3617f566bb2b77ca5f800839cd576c87f3cce746fcb21d2274c0b2164b74cdead92908c0e43d3f84f67ad0f996ed99a89535a932b2dc";
  };
}
