{
  azahar,
  fetchFromGitHub,
  lib,
}:

azahar.overrideAttrs (
  finalAttrs: oldAttrs: {
    pname = "azaharplus";
    version = "2125.1-B";

    src = fetchFromGitHub {
      owner = "AzaharPlus";
      repo = "AzaharPlus";
      tag = "AZAHAR_PLUS_${lib.replaceStrings [ "." "-" ] [ "_" "_" ] finalAttrs.version}";
      postCheckout = ''
        git -C "$out/externals" submodule update --init libzip
        ${oldAttrs.src.postCheckout}
      '';
      hash = "sha256-lBMcUCE1Btg330Hr1gY7i9JPg0FHjrNKXViORUmr75I=";
    };

    cmakeFlags = oldAttrs.cmakeFlags or [ ] ++ [ "-DQT_NO_PRIVATE_MODULE_WARNING=ON" ];
  }
)
