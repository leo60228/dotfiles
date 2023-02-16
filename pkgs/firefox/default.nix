{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "111.0b1";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/111.0b1/linux-x86_64/en-US/firefox-111.0b1.tar.bz2";
    sha512 = "b8cfcd3fa664499a733d9ee57a22e0bbee8c2db6d6d56ceb563c4826d474f99b3f89a3a20f5635614f8268de6ab6508b8c919398b2b5216aac808bc38fcc4bc4";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/111.0b1/linux-x86_64/en-US/firefox-111.0b1.tar.bz2.asc";
    sigSha512 = "53af6e34e88f7d29f515195288ea66737bb0eae84f8dc1e82eafa93c87aef3300fb9a1d0204b97b2879c4e8d47eeb4cdbc5c2e6b4193adbbd12ef59548d7724f";
  };
}
