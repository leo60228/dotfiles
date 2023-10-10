{ upd8r, ... }:
self: super:
{
    inherit (upd8r.packages.${self.targetPlatform.system}) upd8r;
}
