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

USES=	gmake ncurses iconv gettext-runtime pkgconfig cargo
USE_GITHUB=	yes
USE_GCC=	yes

BINARY_ALIAS=	g++=${CXX} gcc=${CC} make=${GMAKE} \
				${ARCH:S/amd64/x86_64/}-portbld-freebsd${OSREL}-gcc=${CC} \
				${ARCH:S/amd64/x86_64/}-portbld-freebsd${OSREL}-strip=${STRIP_CMD}
HAS_CONFIGURE=	no
PKGNAMESUFFIX=	${PYTHON_PKGNAMESUFFIX}
ESP_GDB_VERSION=	14.2
ESP_REL_DATE=	20240403

ESP_PORTNAME=	esp-gdb
ESP_ARCH?=	xtensa
# XXX esp-gdb-v14.2_20240403 points to esp-toolchain-bin-wrappers @ ead71c2,
# but the tag does not exist. use the latest. The ref must be later than
# b9b42f8, which fixes a bug, `unrecognized option `--mcpu=esp32s3'`.
ESP_TOOLCHAIN_BIN_WRAPPERS_TAG=	b9b42f8
ESP_XTENSA_DYNCONFIG_TAG=	905b913
ESP_XTENSA_OVERLAY_TAG=	dd1cf19
PLIST=	${PKGDIR}/pkg-plist.${ESP_ARCH}
.if ${ESP_ARCH} == xtensa
ESP_FILE_SCRIPTS=	\
	xtensa-esp-elf-gdb-add-index
ESP_FILE_PROGRAMS=	\
	xtensa-esp-elf-gdb-no-python \
	xtensa-esp-elf-gprof
.elif ${ESP_ARCH} == riscv32
ESP_FILE_SCRIPTS=	\
	riscv32-esp-elf-gdb-add-index
ESP_FILE_PROGRAMS= \
	riscv32-esp-elf-gdb-no-python \
	riscv32-esp-elf-gprof
.endif

GH_TUPLE=	espressif:binutils-gdb:${ESP_PORTNAME}-v${ESP_GDB_VERSION}_${ESP_REL_DATE} \
	espressif:xtensa-dynconfig:${ESP_XTENSA_DYNCONFIG_TAG}:xtensadynconfig/xtensa-dynconfig \
	espressif:xtensa-overlays:${ESP_XTENSA_OVERLAY_TAG}:xtensaoverlay/xtensa-overlays \
	espressif:esp-toolchain-bin-wrappers:${ESP_TOOLCHAIN_BIN_WRAPPERS_TAG}:esptoolchainbinwrappers/esp-toolchain-bin-wrappers

XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_DIR=	${WRKSRC}/esp-toolchain-bin-wrappers/gnu-debugger/unix
CARGO_CARGOTOML=	${XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_DIR}/Cargo.toml
CARGO_CARGOLOCK=	${XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_DIR}/Cargo.lock
CARGO_BUILD_TARGET=	${ARCH:S/amd64/x86_64/}-unknown-freebsd
ESP_ELF_GDB_WRAPPER=	esp-elf-gdb-wrapper

# XXX Makefile has its own do-* target
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
	${REINPLACE_CMD} \
		-e 's|%%PREFIX%%|${PREFIX}|g' \
		-e 's|%%MAKE_JOBS_NUMBER%%|${MAKE_JOBS_NUMBER}|g' \
		${WRKSRC}/build_esp_gdb.sh

do-build:
# see build_esp_gdb.sh
.if ${ESP_ARCH} == xtensa
	${CARGO_CARGO_RUN} build \
		--manifest-path ${CARGO_CARGOTOML} \
		--verbose \
		--verbose \
		${CARGO_BUILD_ARGS}
.endif

	(cd ${WRKSRC} && ${SETENV} ${WRK_ENV} ${MAKE_ENV} bash ${WRKSRC}/build_esp_gdb.sh ${ARCH:S/amd64/x86_64/}-portbld-freebsd${OSREL} ${ESP_ARCH} without_python)

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/${PORTNAME}/bin \
		${STAGEDIR}${PREFIX}/${PORTNAME}/share \
		${STAGEDIR}${PREFIX}/${PORTNAME}/include
.if ${ESP_ARCH} == xtensa
	${MKDIR} ${STAGEDIR}${PREFIX}/${PORTNAME}/lib
.endif

.for F in ${ESP_FILE_SCRIPTS}
	${INSTALL_SCRIPT} ${WRKSRC}/dist${PREFIX}/bin/${F} ${STAGEDIR}${PREFIX}/${PORTNAME}/bin/
.endfor
.for F in ${ESP_FILE_PROGRAMS}
	${INSTALL_PROGRAM} ${WRKSRC}/dist${PREFIX}/bin/${F} ${STAGEDIR}${PREFIX}/${PORTNAME}/bin/
.endfor
.if ${ESP_ARCH} == xtensa
	${STRIP_CMD} ${WRKSRC}/dist${PREFIX}/lib/*
	(cd ${WRKSRC}/dist${PREFIX}/lib && ${COPYTREE_BIN} . ${STAGEDIR}${PREFIX}/${PORTNAME}/lib)
.endif
	(cd ${WRKSRC}/dist${PREFIX}/share && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/${PORTNAME}/share)
	(cd ${WRKSRC}/dist${PREFIX}/include && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/${PORTNAME}/include)
.if ${ESP_ARCH} == xtensa
.for CHIP in esp32 esp32s2 esp32s3 esp
	${INSTALL_PROGRAM} ${CARGO_TARGET_DIR}/release/${ESP_ELF_GDB_WRAPPER} ${STAGEDIR}${PREFIX}/${PORTNAME}/bin/${ESP_ARCH}-${CHIP}-elf-gdb
.endfor
.endif

.include <bsd.port.post.mk>
