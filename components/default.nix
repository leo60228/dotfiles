let
  lib = import ../lib;
in
builtins.listToAttrs (
  map
    (x: {
      name = x;
      value = lib.componentize "../components/${x}.nix";
    })
    (
      builtins.filter (x: x != "default") (
        map (
          x:
          builtins.elemAt (
            let
              match = (builtins.match "(.*)\.nix" x);
            in
            if match == null then [ "default" ] else match
          ) 0
        ) (builtins.attrNames (builtins.readDir ./.))
      )
    )
)
