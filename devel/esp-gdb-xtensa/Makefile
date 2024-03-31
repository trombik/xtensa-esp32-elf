PORTNAME=	${ESP_PORTNAME}-${ESP_ARCH}
DISTVERSION=	${ESP_GDB_VERSION}.${ESP_REL_DATE}
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
USES=	gmake ncurses iconv python gettext-runtime
USE_GITHUB=	yes
USE_GCC=	yes

BINARY_ALIAS=	g++=${CXX} gcc=${CC} make=${GMAKE} \
				${ARCH:S/amd64/x86_64/}-portbld-freebsd${OSREL}-gcc=${CC} \
				python=${PYTHON_CMD}
GNU_CONFIGURE=	yes
PKGNAMESUFFIX=	${PYTHON_PKGNAMESUFFIX}
ESP_GDB_VERSION=	12.1
ESP_REL_DATE=	20221002

ESP_PORTNAME=	esp-gdb
ESP_ARCH?=	xtensa
ESP_XTENSACONFIG_LIB_TAG=	6b5601c
ESP_XTENSA_OVERLAY_TAG=	dd1cf19
PLIST=	${PKGDIR}/pkg-plist.${ESP_ARCH}
.if ${ESP_ARCH} == xtensa
ESP_FILE_SCRIPTS=	\
	xtensa-esp-elf-gdb-add-index \
	xtensa-esp32-elf-gdb \
	xtensa-esp32s2-elf-gdb \
	xtensa-esp32s3-elf-gdb
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
	espressif:esp-xtensaconfig-lib:${ESP_XTENSACONFIG_LIB_TAG}:xtensaconfig/xtensaconfig \
	espressif:xtensa-overlays:${ESP_XTENSA_OVERLAY_TAG}:xtensaoverlay/xtensaconfig/config

.include <bsd.port.pre.mk>

pre-configure:
	${REINPLACE_CMD} \
		-e 's|%%CC%%|${CC}|g' \
		-e 's|%%CXX%%|${CXX}|g' \
		-e 's|%%USE_GCC%%|${USE_GCC}|g' \
		${WRKSRC}/xtensaconfig/Makefile
	${REINPLACE_CMD} \
		-e 's|%%PREFIX%%|${PREFIX}|g' \
		-e 's|%%PYTHON_INCLUDEDIR%%|${PYTHON_INCLUDEDIR}|g' \
		-e 's|%%PYTHON_LIBDIR%%|${PYTHON_LIBDIR}|g' \
		-e 's|%%PYTHON_VER%%|${PYTHON_VER}|g' \
		${WRKSRC}/build_esp_gdb.sh

do-build:
	(cd ${WRKSRC} && ${SETENVI} ${MAKE_ENV} bash ${WRKSRC}/build_esp_gdb.sh ${ARCH:S/amd64/x86_64/}-portbld-freebsd${OSREL} ${ESP_ARCH} ${PYTHON_VERSION})

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/${PORTNAME}/bin \
		${STAGEDIR}${PREFIX}/${PORTNAME}/share \
		${STAGEDIR}${PREFIX}/${PORTNAME}/include \
		${STAGEDIR}${PREFIX}/${PORTNAME}/lib
.for F in ${ESP_FILE_SCRIPTS}
	${INSTALL_SCRIPT} ${WRKSRC}/dist${PREFIX}/bin/${F} ${STAGEDIR}${PREFIX}/${PORTNAME}/bin/
.endfor
.for F in ${ESP_FILE_PROGRAMS}
	${INSTALL_PROGRAM} ${WRKSRC}/dist${PREFIX}/bin/${F} ${STAGEDIR}${PREFIX}/${PORTNAME}/bin/
.endfor
	${STRIP_CMD} ${WRKSRC}/dist${PREFIX}/lib/*
	(cd ${WRKSRC}/dist${PREFIX}/lib && ${COPYTREE_BIN} . ${STAGEDIR}${PREFIX}/${PORTNAME}/lib)
	(cd ${WRKSRC}/dist${PREFIX}/share && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/${PORTNAME}/share)
	(cd ${WRKSRC}/dist${PREFIX}/include && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/${PORTNAME}/include)

.include <bsd.port.post.mk>
