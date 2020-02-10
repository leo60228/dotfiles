{ rustChannelOf, lowPrio }:

rec {
  channel = rustChannelOf {
    channel = "nightly";
    date = "2020-01-31";
  };
  rust = channel.rust.override {
    extensions = [ "clippy-preview" "rls-preview" "rust-src" "rust-analysis" ];
    targets = [
      "x86_64-unknown-linux-gnu"
      "x86_64-unknown-linux-musl"
      "armv7-linux-androideabi"
      "thumbv7m-none-eabi"
      "wasm32-unknown-unknown"
      "x86_64-unknown-linux-musl"
      "riscv64gc-unknown-none-elf"
    ];
  };
}
