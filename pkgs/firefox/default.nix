{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "112.0b9";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0b9/linux-x86_64/en-US/firefox-112.0b9.tar.bz2";
    sha512 = "d68444e26c98464144c4fa4aecfdc87e79832ec0a56a73237e977d80b781711a77ba9ad032df728550d79e1ec84ef0ff8f5302edb4563b65d1b086ba918bad70";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0b9/linux-x86_64/en-US/firefox-112.0b9.tar.bz2.asc";
    sigSha512 = "50df6d4f8775eeaeb202eed0a153095e5e4d7e31f36ad3572ba1f3a2d0cc369404775d7f9cfc34accacf106492c0d46d4ce0537ad26f5a452a3e19df695c6c42";
  };
}
