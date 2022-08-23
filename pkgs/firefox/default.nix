{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "105.0b1";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b1/linux-x86_64/en-US/firefox-105.0b1.tar.bz2";
    sha512 = "f2d96224674d0609dc607129e5388182871bbf82512bc849b77eb968600f28fa75349b120b49b82f20bb5b9749d78f6a7d9e54cdc955485856d81ecdda039019";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b1/linux-x86_64/en-US/firefox-105.0b1.tar.bz2.asc";
    sigSha512 = "a5ada047653abd939177c36bcf01e0305728ff3a8b665f8247d250158f80588fac4957c87cfce57bc229d680c83960230e100a2aa688914cff6479489020cf2d";
  };
}
