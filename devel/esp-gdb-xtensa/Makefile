PORTNAME=	${ESP_PORTNAME}-${ESP_ARCH}
DISTVERSION=	${ESP_GDB_VERSION}.${ESP_REL_DATE}
PORTREVISION=	3
CATEGORIES=	devel

MAINTAINER=	y@trombik.org
COMMENT?=	GDB for ESP32 family

LICENSE=	GPLv2
LICENSE_FILE=	${WRKSRC}/COPYING

BUILD_DEPENDS=	bash:shells/bash \
		makeinfo:print/texinfo
LIB_DEPENDS= \
		libexpat.so:textproc/expat2 \
		libgmp.so:math/gmp \
		libmpfr.so:math/mpfr \
		libzstd.so:archivers/zstd \
		libdebuginfod.so:devel/elfutils \
		libxxhash.so:devel/xxhash

WWW=	https://github.com/espressif/binutils-gdb

ESP_PORTNAME=	esp-gdb
ESP_ARCH?=	xtensa
ESP_GDB_VERSION=	17.1
ESP_REL_DATE=	20260402
ESP_TOOLCHAIN_BIN_WRAPPERS_TAG=	925bd7c
ESP_XTENSA_DYNCONFIG_TAG=	905b913
ESP_XTENSA_OVERLAY_TAG=	dd1cf19

USES=	gmake ncurses iconv gettext-runtime pkgconfig cargo compiler
USE_GITHUB=	yes
USE_GCC=	yes

# see build_esp_gdb.sh
GNU_CONFIGURE=	yes
CFLAGS=	-Wno-psabi
CXXFLAGS=	-Wno-psabi
PREFIX=	${LOCALBASE}/${PORTNAME}
CROSS_HOST=	${ARCH}-portbld-${OPSYS:tl}${OSREL}
CONFIGURE_TARGET=	${ESP_ARCH}-esp-elf
CONFIGURE_ARGS=	\
	--host=${CROSS_HOST} \
	--target=${ESP_ARCH}-esp-elf \
	--build=${CROSS_HOST} \
	--disable-werror \
	--with-expat=${LOCALBASE} \
	--disable-threads \
	--disable-sim \
	--disable-nls \
	--disable-binutils \
	--disable-ld \
	--disable-gas \
	--disable-source-highlight \
	--prefix=${LOCALBASE} \
	--with-gmp=${LOCALBASE} \
	--with-libgmp-prefix=${LOCALBASE} \
	--with-mpc=${LOCALBASE} \
	--with-mpfr=${LOCALBASE} \
	--with-pkgversion="${ESP_PORTNAME}" \
	--with-curses \
	--enable-tui \
	--enable-threads=posix
# see bfd/configure
CONFIGURE_ENV=	CC_FOR_BUILD=${CC}

PLIST=	${PKGDIR}/pkg-plist.${ESP_ARCH}

GH_TUPLE=	espressif:binutils-gdb:${ESP_PORTNAME}-v${ESP_GDB_VERSION}_${ESP_REL_DATE} \
	espressif:xtensa-dynconfig:${ESP_XTENSA_DYNCONFIG_TAG}:xtensadynconfig/xtensa-dynconfig \
	espressif:xtensa-overlays:${ESP_XTENSA_OVERLAY_TAG}:xtensaoverlay/xtensa-overlays \
	espressif:esp-toolchain-bin-wrappers:${ESP_TOOLCHAIN_BIN_WRAPPERS_TAG}:esptoolchainbinwrappers/esp-toolchain-bin-wrappers

XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_DIR=	${WRKSRC}/esp-toolchain-bin-wrappers/gnu-debugger/unix
CARGO_CARGOTOML=	${XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_DIR}/Cargo.toml
CARGO_CARGOLOCK=	${XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_DIR}/Cargo.lock
CARGO_BUILD_TARGET=	${ARCH:S/amd64/x86_64/}-unknown-freebsd
ESP_ELF_GDB_WRAPPER=	esp-elf-gdb-wrapper

# XXX this Makefile has its own targets
CARGO_INSTALL=	no
CARGO_BUILD=	no
CARGO_ENV=	\
	CARGO_BUILD_JOBS=${MAKE_JOBS_NUMBER} \
	CARGO_TARGET_${CARGO_BUILD_TARGET:S/-/_/g:tu}_LINKER="${CC}"

.include <bsd.port.pre.mk>

# a helper target to update distinfo
updatecrates: makelockfile installlockfile
	${MAKE} cargo-crates > Makefile.crates
	${MAKE} makesum

makelockfile: extract cargo-crates-generate-lockfile
	${CP} ${CARGO_CARGOLOCK} ${FILESDIR}/Cargo.lock

installlockfile:
	${CP} ${FILESDIR}/Cargo.lock ${CARGO_CARGOLOCK}

pre-configure:	installlockfile

pre-build:
# see build_esp_gdb.sh
.if ${ESP_ARCH} == xtensa
	${CARGO_CARGO_RUN} build \
		--manifest-path ${CARGO_CARGOTOML} \
		--verbose \
		--verbose \
		${CARGO_BUILD_ARGS}
	(cd ${WRKSRC}/xtensa-dynconfig && \
	${SETENVI} ${WRK_ENV} ${MAKE_ENV} CONF_DIR=${WRKSRC}/xtensa-overlays \
		${MAKE_CMD} ${MAKE_FLAGS} ${MAKEFILE} ${MAKE_ARGS} ${INSTALL_TARGET})
.endif

post-install:
.if ${ESP_ARCH} == xtensa
	${INSTALL_LIB} ${WRKSRC}/xtensa-dynconfig/*.so ${STAGEDIR}${PREFIX}/lib
.for CHIP in esp32 esp32s2 esp32s3
	${INSTALL_PROGRAM} ${WRKDIR}/target/release/esp-elf-gdb-wrapper ${STAGEDIR}${PREFIX}/bin/${ESP_ARCH}-${CHIP}-elf-gdb
.endfor
.endif
.if ${ESP_ARCH} == rsicv32
	${INSTALL_PROGRAM} ${WRKDIR}/target/release/esp-elf-gdb-wrapper ${STAGEDIR}${PREFIX}/bin/${ESP_ARCH}-esp-elf-gdb
.endif

.include <bsd.port.post.mk>
