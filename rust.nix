{ rustChannelOf, lowPrio }:

rec {
  channel = rustChannelOf {
    channel = "nightly";
    date = "2019-07-22";
  };
  clippyChannel = rustChannelOf {
    channel = "nightly";
    date = "2019-07-19";
  };
  rust = channel.rust.override {
    targets = [
      "x86_64-unknown-linux-gnu"
      "armv7-linux-androideabi"
      "wasm32-unknown-unknown"
    ];
  };
  clippy = lowPrio clippyChannel.clippy-preview;
}
