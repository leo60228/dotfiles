{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  version = "102.0b8";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/102.0b8/linux-x86_64/en-US/firefox-102.0b8.tar.bz2";
    sha512 = "8e26219282b0bc46ed03b7dd1f19f942acc6b1d6baa98c1b93fd9722d751f41b0474439a5bbcadf17e8ce9268b1be710783f931684a5475f40960a177ed59ceb";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/102.0b8/linux-x86_64/en-US/firefox-102.0b8.tar.bz2.asc";
    sigSha512 = "980a9bb95f3f885a10f91885d1f425cccd05d9d7a3f07dbb7481d8cc7b1326c2eef83adf667944d245c8d1a22416f76e565952c1290403e176337731386ab968";
  };
}
