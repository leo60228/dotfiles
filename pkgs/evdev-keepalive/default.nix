{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  pname = "evdev-keepalive";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "pastaq";
    repo = "evdev-keepalive";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k+bzemHRnElzCJKX2ZTsP2jXHhQpB17l9xswu8hNosQ=";
  };

  postPatch = ''
    substituteInPlace evdev-keepalive@.service --replace-fail /usr/bin $out/bin
  '';

  buildPhase = ''
    runHook preBuild

    cc -O2 evdev_keepalive.c -o evdev_keepalive

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 evdev_keepalive $out/bin/evdev_keepalive
    install -Dm644 evdev-keepalive@.service $out/lib/systemd/system/evdev-keepalive@.service
    install -Dm644 10-evdev-keepalive.rules $out/lib/udev/rules.d/10-evdev-keepalive.rules

    runHook postInstall
  '';
})
