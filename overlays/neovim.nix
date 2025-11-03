{ neovim-nightly-overlay, ... }:
self: super: {
  neovim-unwrapped = (neovim-nightly-overlay.overlays.default self super).neovim-unwrapped;
}
