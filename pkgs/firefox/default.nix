{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "110.0b6";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/110.0b6/linux-x86_64/en-US/firefox-110.0b6.tar.bz2";
    sha512 = "e18b419ab74d89ca15bf878c84733e1fa6242f35698ff340e50bf70166c6365bbebc9a41e0c070273acafbd6e6fcfb3581c376c2d6bd64a42ee3ace6744c1123";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/110.0b6/linux-x86_64/en-US/firefox-110.0b6.tar.bz2.asc";
    sigSha512 = "c57dca2e36f7203f7cc4670c1c892bd4eebed4437cd591c35cfce0f1a369d7ec0c227d3879ba67e72807dd7ebf7af9015044c8b4dd6c6f93b1864baf88221fb4";
  };
}
