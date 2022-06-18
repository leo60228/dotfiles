{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "102.0b9";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/102.0b9/linux-x86_64/en-US/firefox-102.0b9.tar.bz2";
    sha512 = "50ed3c3878c4e618f3889e54505154a9f19a70a2fe95c6559e149e8eef790198459e90908aa3fc66bd2e19bf3c83fe847ba5a97d73ac61e2cd6cca8b66a217bb";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/102.0b9/linux-x86_64/en-US/firefox-102.0b9.tar.bz2.asc";
    sigSha512 = "cf66a4a3fe47982a1b66f1d62afd173c2539f37b69a965207adc4cd14e761d740423b0e7343b30fe8113248067498c60683734b5a1e54af18bbe3291595f5e5b";
  };
}
