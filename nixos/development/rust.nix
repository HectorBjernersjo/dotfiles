{ config, pkgs, ... }:

{
 #  environment.systemPackages = with pkgs;[
 #        cargo rustc rustfmt clippy rust-analyzer rustlings wasm-pack binaryen trunk rustup cargo-generate wasm-bindgen-cli bacon
 #  ];
 #
 #  # environment.systemPackages = with pkgs;[
 #  #       rustup
 #  # ];
 #
 # environment.variables = {
 #    RUST_SRC_PATH       = "${pkgs.rustPlatform.rustLibSrc}";
 #    PKG_CONFIG_PATH     = "${pkgs.openssl.dev}/lib/pkgconfig";
 #    OPENSSL_DIR         = "${pkgs.openssl.dev}";
 #    OPENSSL_LIB_DIR     = "${pkgs.openssl.out}/lib";
 #    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
 #  };
}
