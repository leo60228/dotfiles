{ vlc }:
vlc.overrideAttrs (oldAttrs: {
  patches = (if oldAttrs ? patches then oldAttrs.patches else []) ++ [ ./files/vlc-bilinear-album-art.patch ];
})
