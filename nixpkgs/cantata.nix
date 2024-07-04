self: super: {
  cantata = super.cantata.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [ ../files/cantata-track-art.patch ];
  });
}
