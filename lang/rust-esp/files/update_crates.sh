#!/bin/sh
set -e

MAKEFILE_CRATES=`make -V MAKEFILE_CRATES`
CARGOTOML_FILES="Cargo.toml \
    library/Cargo.toml
    src/bootstrap/Cargo.toml \
    src/tools/cargo/Cargo.toml \
    src/tools/rust-analyzer/Cargo.toml
    src/tools/rustbook/Cargo.toml \
"

make clean
make patch
rm -f "${MAKEFILE_CRATES}"

# generate a list of crates for the build
for F in ${CARGOTOML_FILES}; do
    echo "Generating CARGO_CRATES for ${F}..."
    make -f Makefile.makecrates CARGOTOML_FILE="${F}" cargo-crates | \
        sed -e 's/CARGO_CRATES=/CARGO_CRATES+=/' >> "${MAKEFILE_CRATES}"
done

# update distinfo
make makesum

# remove duplicates from distinfo
sort -u < distinfo > distinfo.new
mv distinfo.new distinfo
