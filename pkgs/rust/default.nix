{ rustChannelOf, lowPrio, small ? false }:

rec {
  channel = rustChannelOf {
    channel = "nightly";
    date = "2023-11-02";
    sha256 = "sha256-LEzmVt0K3MeZe61P051wMlvhtLMKW5lk5ZvhULpRlv0=";
  };
  rust = channel.rust.override {
    extensions = [ "clippy-preview" "rust-src" "rust-analysis" ];
    targets = if small then [
      "x86_64-unknown-linux-gnu"
    ] else [
      "x86_64-unknown-linux-gnu"
      "x86_64-unknown-linux-musl"
      "armv7-linux-androideabi"
      "armv7-unknown-linux-musleabihf"
      "thumbv6m-none-eabi"
      "thumbv7m-none-eabi"
      "thumbv7em-none-eabi"
      "thumbv7em-none-eabihf"
      "wasm32-unknown-unknown"
      "x86_64-unknown-linux-musl"
      "riscv64gc-unknown-none-elf"
      "riscv32imc-unknown-none-elf"
    ];
  };
}
