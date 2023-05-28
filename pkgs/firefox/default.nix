{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "113.0.2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/113.0.2/linux-x86_64/en-US/firefox-113.0.2.tar.bz2";
    sha512 = "e68ef6551d7ad3231e29f445de8f526d6f6b196d86b2fccb7be03497cf8a6b67c202693d34ef117fab4eb78ab3897992e37cb421dd8abe23d3fcbe8e5dcea245";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/113.0.2/linux-x86_64/en-US/firefox-113.0.2.tar.bz2.asc";
    sigSha512 = "b6e2666279eaa1d487a23ee46f199d8c26595e43e36bd42b69b2aa5c7d12c70519c8543299a4f13fa44c2c050ba278e319da9fe9460cdceaf546c476f18fe6a9";
  };
}
