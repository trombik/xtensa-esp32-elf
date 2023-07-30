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
USES=	gmake ncurses iconv
USE_GITHUB=	yes
USE_GCC=	yes

BINARY_ALIAS=	g++=${CXX} gcc=${CC} make=${GMAKE} \
				${ARCH:S/amd64/x86_64/}-portbld-freebsd${OSREL}-gcc=${CC}
GNU_CONFIGURE=	yes
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
	espressif:esp-xtensaconfig-lib:${ESP_XTENSACONFIG_LIB_TAG}:xtensaconfig/xtensaconfig \
	espressif:xtensa-overlays:${ESP_XTENSA_OVERLAY_TAG}:xtensaoverlay/xtensaconfig/config

pre-configure:
	${REINPLACE_CMD} \
		-e 's|%%CC%%|${CC}|g' \
		-e 's|%%CXX%%|${CXX}|g' \
		-e 's|%%USE_GCC%%|${USE_GCC}|g' \
		${WRKSRC}/xtensaconfig/Makefile
	${REINPLACE_CMD} \
		-e 's|%%PREFIX%%|${PREFIX}|g' \
		${WRKSRC}/build_esp_gdb.sh

do-build:
	(cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} bash ${WRKSRC}/build_esp_gdb.sh ${ARCH:S/amd64/x86_64/}-portbld-freebsd${OSREL} ${ESP_ARCH} without_python)

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}/${PORTNAME}/bin
.for F in ${ESP_FILE_SCRIPTS}
	${INSTALL_SCRIPT} ${WRKSRC}/dist${PREFIX}/bin/${F} ${STAGEDIR}${PREFIX}/${PORTNAME}/bin/
.endfor
.for F in ${ESP_FILE_PROGRAMS}
	${INSTALL_PROGRAM} ${WRKSRC}/dist${PREFIX}/bin/${F} ${STAGEDIR}${PREFIX}/${PORTNAME}/bin/
.endfor

.include <bsd.port.mk>
