self: super: {
  cantata = (super.cantata.override { ffmpeg = self.ffmpeg_6; }).overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [ ../files/cantata-track-art.patch ];
  });
}
