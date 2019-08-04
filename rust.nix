{ rustChannelOf, lowPrio }:

rec {
  channel = rustChannelOf {
    channel = "nightly";
    date = "2019-07-25";
  };
  rust = channel.rust.override {
    targets = [
      "x86_64-unknown-linux-gnu"
      "armv7-linux-androideabi"
      "wasm32-unknown-unknown"
      "x86_64-unknown-linux-musl"
    ];
    extensions = [ "rust-src" ];
  };
}
