{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "104.0b3";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b3/linux-x86_64/en-US/firefox-104.0b3.tar.bz2";
    sha512 = "b9a085b6e32a7bbab8cf12e6afca7c020c4f383fdba19458dcf29e595d456c7dc64237062547c947eae0abe7fb0ff34ded02d5790fea34adddacd333e49ace2b";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b3/linux-x86_64/en-US/firefox-104.0b3.tar.bz2.asc";
    sigSha512 = "78d40b7d4529d7155c1a9f70a98a48fc792b45dcdb1a033918455e165301b251f539cedf53630fdb60170433480c790b07e2c6447d4ffc8128804aa988e64d8d";
  };
}
