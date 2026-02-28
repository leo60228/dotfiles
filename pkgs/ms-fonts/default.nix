{
  lib,
  linkFarm,
  fetchurl,
}:

let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  families = lib.mapAttrs (
    family: fonts:
    lib.mapAttrsToList (
      id:
      { name, hash }:
      {
        name = "share/fonts/truetype/${name}";
        path = fetchurl {
          inherit name hash;
          url = "https://fs.microsoft.com/fs/DesignerFonts/1.7/rawguids/${id}";
        };
      }
    ) fonts
  ) sources;
  fonts = lib.flatten (lib.attrValues families);
in
linkFarm "ms-fonts" fonts
