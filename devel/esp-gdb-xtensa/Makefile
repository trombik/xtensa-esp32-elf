PORTNAME=	${ESP_PORTNAME}-${ESP_ARCH}
DISTVERSION=	${ESP_GDB_VERSION}.${ESP_REL_DATE}
PORTREVISION=	1
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
USES=	gmake ncurses iconv python gettext-runtime pkgconfig
USE_GITHUB=	yes
USE_GCC=	yes

BINARY_ALIAS=	g++=${CXX} gcc=${CC} make=${GMAKE} \
				${ARCH:S/amd64/x86_64/}-portbld-freebsd${OSREL}-gcc=${CC} \
				python=${PYTHON_CMD}
HAS_CONFIGURE=	no
PKGNAMESUFFIX=	${PYTHON_PKGNAMESUFFIX}
ESP_GDB_VERSION=	14.2
ESP_REL_DATE=	20240403

ESP_PORTNAME=	esp-gdb
ESP_ARCH?=	xtensa
# XXX esp-gdb-v14.2_20240403 points to esp-toolchain-bin-wrappers @ ead71c2,
# but the tag does not exist. use the latest.
ESP_TOOLCHAIN_BIN_WRAPPERS_TAG=	62776e9
ESP_XTENSA_DYNCONFIG_TAG=	905b913
ESP_XTENSA_OVERLAY_TAG=	dd1cf19
PLIST=	${PKGDIR}/pkg-plist.${ESP_ARCH}
.if ${ESP_ARCH} == xtensa
ESP_FILE_SCRIPTS=	\
	xtensa-esp-elf-gdb-add-index
ESP_FILE_PROGRAMS=	\
	xtensa-esp-elf-gdb-${PYTHON_VER} \
	xtensa-esp-elf-gprof
.elif ${ESP_ARCH} == riscv32
ESP_FILE_SCRIPTS=	\
	riscv32-esp-elf-gdb-add-index
ESP_FILE_PROGRAMS= \
	riscv32-esp-elf-gdb-${PYTHON_VER} \
	riscv32-esp-elf-gprof
.endif

GH_TUPLE=	espressif:binutils-gdb:${ESP_PORTNAME}-v${ESP_GDB_VERSION}_${ESP_REL_DATE} \
	espressif:xtensa-dynconfig:${ESP_XTENSA_DYNCONFIG_TAG}:xtensadynconfig/xtensa-dynconfig \
	espressif:xtensa-overlays:${ESP_XTENSA_OVERLAY_TAG}:xtensaoverlay/xtensa-overlays \
	espressif:esp-toolchain-bin-wrappers:${ESP_TOOLCHAIN_BIN_WRAPPERS_TAG}:esptoolchainbinwrappers/esp-toolchain-bin-wrappers

.include <bsd.port.pre.mk>

pre-configure:
	${REINPLACE_CMD} \
		-e 's|%%PREFIX%%|${PREFIX}|g' \
		-e 's|%%PYTHON_INCLUDEDIR%%|${PYTHON_INCLUDEDIR}|g' \
		-e 's|%%PYTHON_LIBDIR%%|${PYTHON_LIBDIR}|g' \
		-e 's|%%PYTHON_VER%%|${PYTHON_VER}|g' \
		-e 's|%%MAKE_JOBS_NUMBER%%|${MAKE_JOBS_NUMBER}|g' \
		${WRKSRC}/build_esp_gdb.sh

do-build:
	(cd ${WRKSRC} && ${SETENV} ${WRK_ENV} ${MAKE_ENV} bash ${WRKSRC}/build_esp_gdb.sh ${ARCH:S/amd64/x86_64/}-portbld-freebsd${OSREL} ${ESP_ARCH} ${PYTHON_VERSION})

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
	(cd ${STAGEDIR}${PREFIX}/${PORTNAME}/bin && ln -s ${ESP_ARCH}-esp-elf-gdb-${PYTHON_VER} ${ESP_ARCH}-esp-elf-gdb)
	echo "${PORTNAME}/bin/${ESP_ARCH}-esp-elf-gdb" >> ${TMPPLIST}
.if ${ESP_ARCH} == xtensa
	(cd ${STAGEDIR}${PREFIX}/${PORTNAME}/bin && ln -s ${ESP_ARCH}-esp-elf-gdb-${PYTHON_VER} ${ESP_ARCH}-esp32-elf-gdb)
	echo "${PORTNAME}/bin/${ESP_ARCH}-esp32-elf-gdb" >> ${TMPPLIST}
.endif

.include <bsd.port.post.mk>
