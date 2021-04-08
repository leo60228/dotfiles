{ hauntbot, ... }:
self: super:
{
    inherit (hauntbot.packages.${self.targetPlatform.system}) hauntbot;
}
