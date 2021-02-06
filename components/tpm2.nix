let lib = import ../lib; in
lib.makeComponent "tpm2"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      abrmd.enable = true;
    };
  };
})
