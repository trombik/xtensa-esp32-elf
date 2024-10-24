# `rust-esp`

This is a FreeBSD port of [Rust for Xtensa architecture](https://github.com/esp-rs/rust).

## Status

* successfully built with `poudriere`
* it can compile [esp-idf-template](https://github.com/esp-rs/esp-idf-template)
* it can compile [esp-template](https://github.com/esp-rs/esp-template)

## Usage

Make sure that you can compile `${IDF_PATH}/examples/get-started/blink` with
`idf.py`, i.e.  all the tool-chains are installed, all the required
environment variables are defined, and all the required directories are
included in`${PATH}`.

Add `bin` directories of `rust-esp` and `esp-llvm-embedded-toolchain` to
`${PATH}`.

Define additional environment variables:

```
LIBCLANG_PATH="${LOCALBASE}/esp-llvm-embedded-toolchain-libs-clang/lib"
CLANG_PATH="${LOCALBASE}/esp-llvm-embedded-toolchain/bin/clang"
RUST_ESP_SRC=${LOCALBASE}/rust-esp-src
```

Define `RISCV_GCC` and `XTENSA_GCC`. Their values should point to `gcc`
binaries for `riscv32` and `xtensa`. For example, if `esp-idf` version is 5.3:

```
RISCV_GCC=${LOCALBASE}/riscv32-esp-elf-idf53/bin/riscv32-esp-elf-gcc
XTENSA_GCC=${LOCALBASE}/xtensa-esp-elf-idf53/bin/xtensa-esp-elf-gcc
```

Note that `esp-idf` version 5.3 is not supported by `rust-esp` as of this
writing. For example,
[Fix for ESP-IDF 5.3 #485](https://github.com/esp-rs/esp-idf-svc/pull/485)
has not been merged to a released version. See
[Supported ESP-IDF versions #188](https://github.com/esp-rs/esp-idf-template/issues/188).

## `cryptography` python library

`espressif` pins `cryptography` to binary package. They host their own
binaries for their supported architectures. When installation of
`cryptography` fails, remove the constraint from
`${HOME}/.espressif/espidf.constraints.v${IDF_VERSION}.txt`
by commenting out.

```
cryptography>=2.1.4,<42
# --only-binary cryptography
```
