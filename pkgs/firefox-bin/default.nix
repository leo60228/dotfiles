{ firefox-bin-unwrapped, wrapFirefox }:

let
  unwrapped = firefox-bin-unwrapped.override {
    channel = "release";
    generated = import ./release_sources.nix;
  };

in
wrapFirefox unwrapped {
  pname = "firefox-bin";
}
