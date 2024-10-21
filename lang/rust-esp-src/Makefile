PORTNAME=	rust-esp-src
MASTERDIR=	${.CURDIR}/../rust-esp
COMMENT=	Rust source component for ESP

LIB_DEPENDS=
NO_ARCH=	yes
DESCR=	${.CURDIR}/pkg-descr

# see .github/workflows/build-rust-src.yaml in esp-rs/rust-build
ESPRUST_BUILD_ARGS=	dist rust-src
ESPRUST_CONFIGURE_ARGS=	--experimental-targets=Xtensa --release-channel=nightly --release-description="${ESPRUST_VERSION}" --enable-extended --dist-compression-formats='xz'
ESPRUST_RUSTUP_COMPONENT_NAME?=	rust-src-${ESPRUST_VERSION}
ESPRUST_COMPONENTS?=	\
	rust-src-${ESPRUST_COMPONENTS_VERSION}

.include "${MASTERDIR}/Makefile"
