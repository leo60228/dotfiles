{
  branch ? "n",
  qt6Packages,
  fetchFromGitHub,
  fetchurl,
}:

let
  # Fetched from https://api.citra-emu.org/gamedb
  # Please make sure to update this when updating citra!
  compat-list = fetchurl {
    name = "citra-compat-list";
    url = "https://web.archive.org/web/20231111133415/https://api.citra-emu.org/gamedb";
    hash = "sha256-J+zqtWde5NgK2QROvGewtXGRAWUTNSKHNMG6iu9m1fU=";
  };
in
{
  n = qt6Packages.callPackage ./generic.nix rec {
    pname = "citra-n";
    version = "r8433057";

    src = fetchFromGitHub {
      owner = "PabloMK7";
      repo = "citra";
      rev = "${version}";
      sha256 = "LsRBddduEehqZTwBbEkZaTqWPDywoAOAA5zGtV7Va+U=";
      fetchSubmodules = true;
    };

    inherit branch compat-list;
  };
}
.${branch}
