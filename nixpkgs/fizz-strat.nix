{ fizz-strat, ... }:
self: super:
{
    inherit (fizz-strat.packages.${self.targetPlatform.system}) fizz-strat;
}
