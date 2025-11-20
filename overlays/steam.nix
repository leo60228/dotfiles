self: super:

{
  steam = super.steam.override {
    extraPkgs = p: [ p.kdePackages.breeze ];
    extraEnv = {
      MANGOHUD = true;
      LD_PRELOAD = "${self.mangohud}/lib/mangohud/libMangoHud_shim.so";
    };
  };
}
