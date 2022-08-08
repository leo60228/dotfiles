{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "104.0b7";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b7/linux-x86_64/en-US/firefox-104.0b7.tar.bz2";
    sha512 = "77ec8d2c7302ea3948dc530f9c0afa4178a326700970894eeb7d8a4b76bcd913f8511033897f9ad60ed7cb106670b24fe75fdbeac3c5aaae859840288ffaa11f";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b7/linux-x86_64/en-US/firefox-104.0b7.tar.bz2.asc";
    sigSha512 = "37bfd1ba943577eb37243802a42cf098f97b7e39d51e57f453bf254cc19eb63903da581b966422d45a00d9fd9dd3d1eec76aa6b4352e15d990b12e06b93c1903";
  };
}
