{ lib, stdenv, fetchFromGitHub, nodejs, bash, nodePackages, unzip }:

stdenv.mkDerivation rec {
  pname = "openasar";
  version = "unstable-2022-12-02";

  src = fetchFromGitHub {
    owner = "GooseMod";
    repo = "OpenAsar";
    rev = "ad9b161744b27acc5e333ee70df11afca09301ef";
    hash = "sha256-Q+mkTY0gYRYS8GJtahRzpss8orZOkKjNE0T/ShjwTcY=";
  };

  postPatch = let
    unzip-fixed = unzip.overrideAttrs (oldAttrs: {
      buildFlags = oldAttrs.buildFlags ++ [ "LOCAL_UNZIP=-DNO_LCHMOD" ]; # TODO: this is fixed upstream in 22.11, i should update already
    });
  in ''
    # Hardcode unzip path
    substituteInPlace ./src/updater/moduleUpdater.js \
      --replace \'unzip\' \'${unzip-fixed}/bin/unzip\'
    # Remove auto-update feature
    echo "module.exports = async () => log('AsarUpdate', 'Removed');" > ./src/asarUpdate.js
  '';

  buildPhase = ''
    runHook preBuild

    substituteInPlace src/index.js --replace 'nightly' '${version}'
    ${nodejs}/bin/node scripts/strip.js
    ${nodePackages.asar}/bin/asar pack src app.asar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install app.asar $out

    runHook postInstall
  '';

  doCheck = false;

  meta = with lib; {
    description = "Open-source alternative of Discord desktop's \"app.asar\".";
    homepage = "https://openasar.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ pedrohlc ];
    platforms = nodejs.meta.platforms;
  };
}
