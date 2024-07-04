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
    mkdir -p $out

    export HOME=$(mktemp -d)
    echo $HOME

    export YARN_ENABLE_TELEMETRY=0
    export YARN_COMPRESSION_LEVEL=0

    cache="$(yarn config get cacheFolder)"
    if ! yarn install --immutable --mode skip-build; then
      cp yarn.lock yarn.lock.bak
      yarn install --mode skip-build
      diff -u yarn.lock.bak yarn.lock > yarn.lock.diff
      echo "yarn build failed! diff generated as yarn.lock.diff"
      exit 1
    fi

    cp -r $cache/* $out/
  '';

  outputHashAlgo = "sha256";
  outputHash = hash;
  outputHashMode = "recursive";
}
