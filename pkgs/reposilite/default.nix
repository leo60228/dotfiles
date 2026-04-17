{
  stdenv,
  fetchMavenArtifact,
  jdk,
  makeWrapper,
  writeShellScript,
  lib,
  curl,
  yq,
  common-updater-scripts,
}:
stdenv.mkDerivation rec {
  pname = "reposilite-bin";
  version = "3.5.28";

  src = fetchMavenArtifact {
    groupId = "com.reposilite";
    artifactId = "reposilite";
    inherit version;
    classifier = "all";
    repos = [ "https://maven.reposilite.com/releases" ];
    hash = "sha256-sKbwO5Lk/DeRQhO3c2zHuHe/CPdb4wRLzG55tP7DVVE=";
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
