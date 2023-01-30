{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "110.0b7";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/110.0b7/linux-x86_64/en-US/firefox-110.0b7.tar.bz2";
    sha512 = "fd03667f8c8b417d841be33eb0384039075d624372ca07a8e3fc2be848bcd6aece712580b993f40e3f6b7d08487b139d70b0c46e2ed82ffb3914135c3b7fcd3b";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/110.0b7/linux-x86_64/en-US/firefox-110.0b7.tar.bz2.asc";
    sigSha512 = "865541bcf061be36dfe38d42ebfb1e775067278eeb9d9a0f7f174aa304bf30848d8a2be68307574b818ad37611ca1e001d522a64a86578860fc6f81900a2f79a";
  };
}
