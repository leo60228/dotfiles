{
  lib,
  applyPatches,
  fetchFromGitHub,
  patches ? [ ],
  postPatch ? "",
  yarn-berry,
  gawk,
  gnused,
}:
(applyPatches {
  src = fetchFromGitHub {
    owner = "BlaseballCrabs";
    repo = "mastodon";
    rev = "8a64b32a577b7a7ca23b3ed0f6ad6a56a808ea1b";
    hash = "sha256-yy/U40/Cbc9KC/EVnTRvQqGWrifEiqmx6L737AqfOqk=";
  };
  inherit patches;
  nativeBuildInputs = [
    gawk
    gnused
  ];
  postPatch =
    postPatch
    + lib.optionalString (!(lib.versionAtLeast yarn-berry.version "4.1.0")) ''
      # this is for yarn starting with 4.1.0 because fuck everything amirite
      # see also https://github.com/yarnpkg/berry/pull/6083
      echo "patching cachekey in yarn.lock"
      sed -i -Ee 's|^  checksum: [^/]*/|  checksum: |g;' yarn.lock
    '';
})
// {
  version = "unstable-2024-07-04";
  yarnHash = "sha256-2iud+LfchFMXEv9/qQRTIyVPHJRe1WyljK2KmPMJ4Yg=";
}
