self: super:

{
  steam = super.steam.override {
    extraPkgs = p: [ p.kdePackages.breeze ];
  };
}
