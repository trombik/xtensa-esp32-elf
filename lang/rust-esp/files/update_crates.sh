#!/bin/sh
set -e

MAKEFILE_CRATES=`make -V MAKEFILE_CRATES`
CARGOTOML_FILES="Cargo.toml \
    library/Cargo.toml
    src/bootstrap/Cargo.toml \
    src/tools/cargo/Cargo.toml \
    src/tools/rust-analyzer/Cargo.toml
    src/tools/rustbook/Cargo.toml \
    src/tools/generate-copyright/Cargo.toml \
"

make clean
make patch
echo > "${MAKEFILE_CRATES}"

WRKSRC=`make -V WRKSRC`

# Generate Cargo.lock if it does not exist
for F in ${CARGOTOML_FILES}; do
    F_REALPATH=`realpath ${WRKSRC}/${F}`
    LOCKFILE=`echo ${F_REALPATH} | sed -e 's/\.toml/.lock/'`
    if [ -f ${LOCKFILE} ]; then
        continue
    fi
    echo "Generating Cargo.lock for ${F}..."
    (cd `dirname ${F_REALPATH}` && \
        cargo generate-lockfile --manifest-path=Cargo.toml --lockfile-path=Cargo.lock -Z unstable-options --verbose)
done

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
