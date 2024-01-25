# includes = 

{config, pkgs, lib, ...}:

let
  cfg = config.components;
in

with lib;

{
  options = {
    components._isComponent = mkOption {
      default = true;
      type = types.bool;
    };

    components.__functor = mkOption {
      default = null;
    };

    components._lastComponent = mkOption {
      default = "";
      type = types.str;
    };

    components._name = mkOption {
      default = "";
      type = types.str;
    };
  };

  imports =
    (map 
      (x: ../components + "/${x}.nix")
      (builtins.filter
        (x: x != "default")
        (map 
          (x: builtins.elemAt (let match = (builtins.match "(.*)\.nix" x); in if match == null then ["default"] else match) 0)
          (builtins.attrNames (builtins.readDir ../components))
        )
      )
    );
}
