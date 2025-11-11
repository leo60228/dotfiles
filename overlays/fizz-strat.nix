{ fizz-strat, ... }:
self: super: { inherit (fizz-strat.packages.${self.stdenv.hostPlatform.system}) fizz-strat; }
