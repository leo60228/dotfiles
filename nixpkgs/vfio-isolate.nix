{ vfio-isolate, ... }:
self:
super:

{
    vfio-isolate = self.callPackage ../vfio-isolate { src = vfio-isolate; };
}
