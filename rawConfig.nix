# includes = ./default.nix
sys: (import ./. true).systems.${sys}
