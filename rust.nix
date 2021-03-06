{ rustChannelOf, lowPrio, small ? false }:

rec {
  channel = rustChannelOf {
    channel = "nightly";
    date = "2021-03-25";
    sha256 = "/FDCSO/P4Xk0wlj9yA+N2Hr+Wx+5Dpz1Ra4WxoMjp10=";
  };
  rust = channel.rust.override {
    extensions = [ "clippy-preview" "rls-preview" "rust-src" "rust-analysis" ];
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
