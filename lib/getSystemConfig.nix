let lib = import ./.; in
(nixops: name: {...}: let base = ({
  imports = [ (lib.generateHardware (../hardware + "/${name}")) (../systems + "/${name}") ../modules/componentBase.nix ../modules/base.nix ../modules/external.nix];
}); in (if nixops then base // (import (../hardware + "/${name}")).nixops else base))
