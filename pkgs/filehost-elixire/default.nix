{
  lib,
  pyproject-nix,
  pyproject-build-systems,
  uv2nix,
  callPackage,
  python3,
  writeScriptBin,
}:

let
  baseSet = callPackage pyproject-nix.build.packages {
    python = python3;
  };
  script = uv2nix.lib.scripts.loadScript { script = ./filehost-elixire.py; };
in
writeScriptBin "filehost-elixire" (
  script.renderScript {
    venv = script.mkVirtualEnv {
      pythonSet = baseSet.overrideScope (
        lib.composeManyExtensions [
          pyproject-build-systems.overlays.wheel
          (script.mkOverlay { sourcePreference = "wheel"; })
        ]
      );
    };
  }
)
