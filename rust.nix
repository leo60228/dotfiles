{ rustChannelOf, lowPrio, small ? false }:

rec {
  channel = rustChannelOf {
    channel = "nightly";
    date = "2021-10-22";
    sha256 = "JCneCLySWZ6MU5zYBobVs3O+NfGOyrwyiI8Ks60tj/E=";
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
      "thumbv7m-none-eabi"
      "thumbv7em-none-eabi"
      "thumbv7em-none-eabihf"
      "wasm32-unknown-unknown"
      "x86_64-unknown-linux-musl"
      "riscv64gc-unknown-none-elf"
    ];
  };
}
