# includes = ./lib/*
skip:
let
  lib = import ./lib;
  genSystems =
    generator:
    (
      let
        read = builtins.readDir ./systems;
      in
      builtins.listToAttrs (
        map (x: {
          name = builtins.elemAt (builtins.match "(.*)\\.nix" x) 0;
          value = generator x;
        }) (builtins.filter (x: builtins.getAttr (x) (read) == "regular") (builtins.attrNames read))
      )
    );
  filter =
    invert: systems:
    if skip == null then
      systems
    else
      (
        if skip == true then
          (if invert then systems else { })
        else
          (builtins.intersectAttrs { ${skip} = null; } systems)
      );
in
{
  systems = filter true (genSystems (lib.getSystemConfig false));
  nixops = filter false (genSystems (lib.getSystemConfig true));
}
