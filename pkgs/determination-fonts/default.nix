{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "determination-fonts";
  version = "unstable-2015-11-16";

  src = fetchzip {
    url = "https://web.archive.org/web/20210207211451/https://download813.mediafire.com/0kqb17j6tn5g/2qfrsbd7yks66qk/DTM.ZIP";
    hash = "sha256-nArZp7BzDNshJuiIJnOe0yuxB3o562UMqLOczOqpoqo=";
    extension = "zip";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.behance.net/gallery/31268855/Determination-Better-Undertale-Font";
    maintainers = with maintainers; [ leo60228 ];
    platforms = platforms.all;
  };
}
