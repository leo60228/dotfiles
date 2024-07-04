# this is mostly copied from upstream mastodon packaging, but modified for yarn-berry deps
{
  stdenv,
  nodejs-slim,
  yarn-berry,
  brotli,
  # previous inputs
  glitch-1,
  yarn-deps,
}:
stdenv.mkDerivation {
  pname = "glitch-modules";
  inherit (glitch-1) src version;

  yarnOfflineCache = yarn-deps;

  nativeBuildInputs = [glitch-1.mastodonGems glitch-1.mastodonGems.wrappedRuby] ++ [nodejs-slim yarn-berry brotli];

  RAILS_ENV = "production";
  NODE_ENV = "production";

  buildPhase = ''
    runHook preBuild

    export HOME=$PWD
    # This option is needed for openssl-3 compatibility
    # Otherwise we encounter this upstream issue: https://github.com/mastodon/mastodon/issues/17924
    export NODE_OPTIONS=--openssl-legacy-provider

    export YARN_ENABLE_TELEMETRY=0
    mkdir -p ~/.yarn/berry
    ln -sf $yarnOfflineCache ~/.yarn/berry/cache

    yarn install --immutable --immutable-cache

    patchShebangs ~/bin
    patchShebangs ~/node_modules

    # skip running yarn install
    rm -rf ~/bin/yarn

    OTP_SECRET=precompile_placeholder SECRET_KEY_BASE=precompile_placeholder \
      ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=precompile_placeholder \
      ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=precompile_placeholder \
      ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=precompile_placeholder \
      rails assets:precompile
    yarn cache clean
    rm -rf ~/node_modules/.cache

    # Create missing static gzip and brotli files
    gzip --best --keep ~/public/assets/500.html
    gzip --best --keep ~/public/packs/report.html
    find ~/public/assets -maxdepth 1 -type f -name '.*.json' \
      -exec gzip --best --keep --force {} ';'
    brotli --best --keep ~/public/packs/report.html
    find ~/public/assets -type f -regextype posix-extended -iregex '.*\.(css|js|json|html)' \
      -exec brotli --best --keep {} ';'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/public
    cp -r node_modules $out/node_modules
    cp -r public/assets $out/public
    cp -r public/packs $out/public

    runHook postInstall
  '';
}
