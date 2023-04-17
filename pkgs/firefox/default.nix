{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "112.0.1";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0.1/linux-x86_64/en-US/firefox-112.0.1.tar.bz2";
    sha512 = "fab6bc1026c7e8ddef7f959526d78f5892d25cd2274818317e1c584082f402d41a0de64a08d5d49177561ce9a68bfc24e6f20f878fa12410d655ce1f0978b6da";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0.1/linux-x86_64/en-US/firefox-112.0.1.tar.bz2.asc";
    sigSha512 = "4245096df3c983af9fb6e5a2ce29dfb6cdc925d2786f56395e008f42f6c72bd327cd45626c453093c0b78e00d2d61833e86dd1b7f9e88f624b39004999f70bc2";
  };
}
