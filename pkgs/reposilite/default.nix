{
  stdenv,
  fetchMavenArtifact,
  jdk,
  makeWrapper,
  writeShellScript,
  lib,
  curl,
  jq,
  yq,
  common-updater-scripts,
}:
stdenv.mkDerivation rec {
  pname = "reposilite-bin";
  version = "3.5.13";

  src = fetchMavenArtifact {
    groupId = "com.reposilite";
    artifactId = "reposilite";
    inherit version;
    classifier = "all";
    repos = [ "https://maven.reposilite.com/releases" ];
    hash = "sha256-G9J1nOK1dM8XC+3Mj8uUnNvM5BiUPzOIRT/T5CZzvqo=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    runHook preInstall
    makeWrapper ${jdk}/bin/java $out/bin/reposilite \
      --add-flags "-Xmx40m -jar ${src.jar}" \
      --set JAVA_HOME ${jdk}
    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-reposilite" ''
    set -ex
    export PATH="${
      lib.makeBinPath [
        curl
        yq
        common-updater-scripts
      ]
    }:$PATH"

    NEW_VERSION=$(curl -s 'https://maven.reposilite.com/releases/com/reposilite/reposilite/maven-metadata.xml' | xq -r '.metadata.versioning.latest')

    update-source-version "$UPDATE_NIX_ATTR_PATH" "$NEW_VERSION" --ignore-same-version --source-key=src.jar
  '';
}
