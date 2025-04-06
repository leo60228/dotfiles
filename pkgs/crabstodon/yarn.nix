{
  stdenvNoCC,
  yarn-berry,
  cacert,
  src,
  hash,
}:
stdenvNoCC.mkDerivation {
  name = "yarn-deps";
  nativeBuildInputs = [
    yarn-berry
    cacert
  ];
  inherit src;

  dontInstall = true;

  NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  buildPhase = ''
    export HOME=$(mktemp -d)
    export YARN_ENABLE_TELEMETRY=0

    yarn config set --json supportedArchitectures.os '[ "linux" ]'
    yarn config set --json supportedArchitectures.cpu '[ "arm64", "x64", "ia32" ]'

    cache="$(yarn config get cacheFolder)"
    yarn install --immutable --mode skip-build

    mkdir -p $out
    cp -r $cache/* $out/
  '';

  outputHashAlgo = "sha256";
  outputHash = hash;
  outputHashMode = "recursive";
}
