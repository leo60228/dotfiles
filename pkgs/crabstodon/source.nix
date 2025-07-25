# This file was generated by pkgs.mastodon.updateScript.
{
  fetchFromGitHub,
  applyPatches,
  patches ? [ ],
}:
let
  version = "unstable-2025-07-08";
in
(applyPatches {
  src = fetchFromGitHub {
    owner = "BlaseballCrabs";
    repo = "mastodon";
    rev = "36cb0c10b6d05b2ef66ce10fb6f83f0d20082e11";
    hash = "sha256-xWTCZdkFqd+1q7gHR5LW6iwCTD82INpyvl2wTjGcLbw=";
  };
  patches = patches ++ [ ];
})
// {
  inherit version;
  yarnHash = "sha256-uJ5CborG6I9o1uIKRLaE0eLBqAHQFtpOPqDk7pHpMsI=";
}
