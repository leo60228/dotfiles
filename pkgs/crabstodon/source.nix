# This file was generated by pkgs.mastodon.updateScript.
{
  fetchFromGitHub,
  applyPatches,
  patches ? [ ],
}:
let
  version = "unstable-2025-04-06";
in
(applyPatches {
  src = fetchFromGitHub {
    owner = "BlaseballCrabs";
    repo = "mastodon";
    rev = "d6ca3fd2345369a45c1ee3a232b10fb1cba85079";
    hash = "sha256-GeQ5sJ7Yx3IC5wNha66UmZMFEyYGWLtIbJZWEqInUB0=";
  };
  patches = patches ++ [ ];
})
// {
  inherit version;
  yarnHash = "sha256-QP5x7eWg4nt8h3j6eJ0qr72x0ZYUyNpFL/nvO3U1zBY=";
}
