{
  rust-bin,
}:

{
  rust = rust-bin.selectLatestNightlyWith (
    toolchain:
    toolchain.default.override {
      extensions = [
        "clippy-preview"
        "rust-src"
        "rust-analysis"
      ];
      targets = [
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
    }
  );
}
