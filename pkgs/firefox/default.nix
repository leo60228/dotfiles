{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "104.0b5";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b5/linux-x86_64/en-US/firefox-104.0b5.tar.bz2";
    sha512 = "745031e3ff259376c93e8289bd8a9f893c266c850cbe962ea1259b188490e5fcedb26e506940f7052c5ff1b31bdf5e7bee9a1c15eb95bd9dab5efe61dcaf5e6d";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b5/linux-x86_64/en-US/firefox-104.0b5.tar.bz2.asc";
    sigSha512 = "dc879d841abe4fe913fb714f865dbcf0d02a9c9b268758e14959abf531bf252763a3d0ba95e4d085a5e4efde89a76af0a57d271c6ed6cc57c515f0fc7f3341c8";
  };
}
