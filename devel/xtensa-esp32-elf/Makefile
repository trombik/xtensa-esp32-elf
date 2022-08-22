# Created by: Craig Leres <leres@freebsd.org>

PORTNAME?=	xtensa-esp32-elf
PORTVERSION=	${ESPRESSIF_VERSION:S/esp-//:S/crosstool-ng-//:S/r/.r/:S/-//:S/patch/.p/}
#PORTREVISION=	3
CATEGORIES=	devel
MASTER_SITES=
DISTFILES=
EXTRACT_ONLY=

MAINTAINER=	y@trombik.org
COMMENT?=	Espressif ESP32 toolchain

LICENSE=	GPLv2 LGPL21
LICENSE_COMB=	multi

BROKEN_aarch64=		fails to configure: cannot compute suffix of object files: cannot compile
BROKEN_armv6=		fails to build: failed in step 'Installing pass-2 core C gcc compiler'
BROKEN_armv7=		fails to build: failed in step 'Installing pass-2 core C gcc compiler'

BUILD_DEPENDS=	bash:shells/bash \
		gawk:lang/gawk \
		gpatch:devel/patch \
		${LOCALBASE}/bin/grep:textproc/gnugrep \
		gperf:devel/gperf \
		gsed:textproc/gsed \
		help2man:misc/help2man \
		makeinfo:print/texinfo

# XXX use iconv:wchar_t.
# configure scripts picks -liconv during gcc build from converters/libiconv
# installed by dependencies. fixes error in stage-qa
# XXX use ncurses, which is required by gdb (libtinfow)
USES=		autoreconf:build bison gmake libtool python:3.5+ gettext-runtime iconv:wchar_t ncurses:port

.if ${PORTNAME} == xtensa-esp32-elf
FLAVORS=	idf50 idf44 idf43 idf42
.elif ${PORTNAME} == xtensa-esp32s2-elf || ${PORTNAME} == riscv32-esp-elf
FLAVORS=	idf50 idf44 idf43
.elif ${PORTNAME} == xtensa-esp32s3-elf
FLAVORS=	df50 idf44
.endif
FLAVOR?=	${FLAVORS:[1]}

.if ${FLAVOR} == idf50
MASTER_SITES+= \
		https://github.com/libexpat/libexpat/releases/download/R_2_4_1/:source1 \
		SF/expat/:source1 \
		GNU/gmp/:source2 \
		http://isl.gforge.inria.fr/:source3 \
		GNU/mpc/:source4 \
		http://www.mpfr.org/mpfr-4.1.0/:source5 \
		ftp://ftp.invisible-island.net/ncurses/:source6 \
		GNU/ncurses/:source6 \
		GNU/autoconf/:source7 \
		GNU/automake/:source8 \
		https://www.zlib.net/:source11
DISTFILES+=	\
		expat-2.4.1.tar.gz:source1 \
		gmp-6.2.1.tar.xz:source2 \
		isl-0.24.tar.xz:source3 \
		mpc-1.2.1.tar.gz:source4 \
		mpfr-4.1.0.tar.xz:source5 \
		ncurses-6.2.tar.gz:source6 \
		autoconf-2.69.tar.gz:source7 \
		automake-1.16.1.tar.gz:source8 \
		zlib-1.2.12.tar.gz:source11
.elif ${FLAVOR} == idf43 || ${FLAVOR} == idf44
MASTER_SITES+= \
		https://github.com/libexpat/libexpat/releases/download/R_2_4_1/:source1 \
		SF/expat/:source1 \
		GNU/gmp/:source2 \
		http://isl.gforge.inria.fr/:source3 \
		GNU/mpc/:source4 \
		http://www.mpfr.org/mpfr-3.1.3/:source5 \
		GNU/mpfr/:source5 \
		ftp://ftp.invisible-island.net/ncurses/:source6 \
		GNU/ncurses/:source6 \
		GNU/autoconf/:source7 \
		GNU/automake/:source8 \
		https://sourceforge.net/projects/libpng/files/zlib/1.2.11/:source11
DISTFILES+=	\
		expat-2.4.1.tar.gz:source1 \
		gmp-6.2.0.tar.xz:source2 \
		isl-0.19.tar.xz:source3 \
		mpc-1.1.0.tar.gz:source4 \
		mpfr-4.0.2.tar.xz:source5 \
		ncurses-6.2.tar.gz:source6 \
		autoconf-2.69.tar.gz:source7 \
		automake-1.16.1.tar.gz:source8 \
		zlib-1.2.11.tar.gz:source11
.elif ${FLAVOR} == idf42
MASTER_SITES+= \
		https://github.com/libexpat/libexpat/releases/download/R_2_2_5/:source1 \
		GNU/gmp/:source2 \
		http://isl.gforge.inria.fr/:source3 \
		GNU/mpc/:source4 \
		http://www.mpfr.org/mpfr-3.1.3/:source5 \
		GNU/mpfr/:source5 \
		ftp://ftp.invisible-island.net/ncurses/:source6 \
		GNU/ncurses/:source6 \
		GNU/autoconf/:source7 \
		GNU/automake/:source8 \
		https://sourceforge.net/projects/libpng/files/zlib/1.2.11/:source11
DISTFILES+=	\
		expat-2.2.5.tar.bz2:source1 \
		gmp-6.1.2.tar.xz:source2 \
		isl-0.19.tar.xz:source3 \
		mpc-1.1.0.tar.gz:source4 \
		mpfr-4.0.1.tar.xz:source5 \
		ncurses-6.1.tar.gz:source6 \
		autoconf-2.69.tar.gz:source7 \
		automake-1.16.1.tar.gz:source8 \
		zlib-1.2.11.tar.gz:source11
.endif

idf50_PLIST=	${MASTERDIR}/pkg-plist.${PORTNAME}-${FLAVOR}
idf44_PLIST=	${MASTERDIR}/pkg-plist.${PORTNAME}-${FLAVOR}
idf43_PLIST=	${MASTERDIR}/pkg-plist.${PORTNAME}-${FLAVOR}
idf42_PLIST=	${MASTERDIR}/pkg-plist.${PORTNAME}-${FLAVOR}
idf50_PKGNAMESUFFIX=	-idf50
idf44_PKGNAMESUFFIX=	-idf44
idf43_PKGNAMESUFFIX=	-idf43
idf42_PKGNAMESUFFIX=	-idf42
DISTINFO_FILE=	${MASTERDIR}/distinfo.${PORTNAME}-${FLAVOR}
SUB_FILES=	pkg-message
SUB_LIST=	PREFIX=${PREFIX} PORTNAME=${PORTNAME} PKGNAMESUFFIX=${PKGNAMESUFFIX}

USE_GCC=	9+
USE_GITHUB=	yes
USE_LDCONFIG=	${PREFIX}/${PORTNAME}/libexec/gcc/${PORTNAME}/8.2.0
LDFLAGS+=	-L${LOCALBASE}/lib ${TINFO_LIB}

.if ${FLAVOR} == idf50
ESPRESSIF_VERSION=	esp-2022r1
ESPRESSIF_GCC_VERSION=	11.2.0
TAGNAME=	esp-2022r1
XTENSA_GDB_VERSION=	gdb
GH_TUPLE=	espressif:gcc:${TAGNAME}:source100 \
	espressif:binutils-gdb:${ESPRESSIF_VERSION}-${XTENSA_GDB_VERSION}:source101 \
	espressif:binutils-gdb:${TAGNAME}-binutils:source102 \
	espressif:newlib-esp32:${TAGNAME}:source103 \
	espressif:crosstool-NG:${ESPRESSIF_VERSION}

# crosstool-NG supports custom location to archive files, but it also assumes
# that top directoy of an archive is same as its file name without suffix. due
# to this, arvhives from espressif github repositories must be extracted.
EXTRACT_ONLY+=	${DISTNAME}${EXTRACT_SUFX} \
	espressif-gcc-${TAGNAME}_GH0.tar.gz \
	espressif-binutils-gdb-${TAGNAME}-binutils_GH0.tar.gz \
	espressif-binutils-gdb-${ESPRESSIF_VERSION}-${XTENSA_GDB_VERSION}_GH0.tar.gz \
	espressif-newlib-esp32-${TAGNAME}_GH0.tar.gz
XTENSA_OVERLAYS_TAGNAME=	dd1cf19

.elif ${FLAVOR} == idf43 || ${FLAVOR} == idf44
# XXX the upstream versioning does not match one of the ports
ESPRESSIF_VERSION=	esp-2021r2-patch3
ESPRESSIF_GCC_VERSION=	8.4.0
TAGNAME=	esp-2021r2
XTENSA_GDB_VERSION=	gdb
GH_TUPLE=	espressif:gcc:${TAGNAME}:source100 \
	espressif:binutils-gdb:${ESPRESSIF_VERSION}-${XTENSA_GDB_VERSION}:source101 \
	espressif:binutils-gdb:${TAGNAME}-binutils:source102 \
	espressif:newlib-esp32:${TAGNAME}:source103 \
	espressif:crosstool-NG:${ESPRESSIF_VERSION}

# crosstool-NG supports custom location to archive files, but it also assumes
# that top directoy of an archive is same as its file name without suffix. due
# to this, arvhives from espressif github repositories must be extracted.
EXTRACT_ONLY+=	${DISTNAME}${EXTRACT_SUFX} \
	espressif-gcc-${TAGNAME}_GH0.tar.gz \
	espressif-binutils-gdb-${TAGNAME}-binutils_GH0.tar.gz \
	espressif-binutils-gdb-${ESPRESSIF_VERSION}-${XTENSA_GDB_VERSION}_GH0.tar.gz \
	espressif-newlib-esp32-${TAGNAME}_GH0.tar.gz
XTENSA_OVERLAYS_TAGNAME=	a5ab689

.elif ${FLAVOR} == idf42
ESPRESSIF_VERSION=	esp-2020r3
ESPRESSIF_GCC_VERSION=	8.4.0
TAGNAME=	${ESPRESSIF_VERSION}
.if ${PORTNAME} == riscv32-esp-elf
IGNORE=	ESP-IDF 4.2 does not support riscv32-esp-elf
.else
XTENSA_GDB_VERSION=	gdb
.endif
GH_TUPLE=	espressif:gcc:${TAGNAME}:source100 \
	espressif:binutils-gdb:${TAGNAME}-${XTENSA_GDB_VERSION}:source101 \
	espressif:binutils-gdb:${TAGNAME}-binutils:source102 \
	espressif:newlib-esp32:${TAGNAME}:source103 \
	espressif:crosstool-NG:${TAGNAME}

EXTRACT_ONLY+=	${DISTNAME}${EXTRACT_SUFX} \
	espressif-gcc-${TAGNAME}_GH0.tar.gz \
	espressif-binutils-gdb-${TAGNAME}-binutils_GH0.tar.gz \
	espressif-binutils-gdb-${TAGNAME}-${XTENSA_GDB_VERSION}_GH0.tar.gz \
	espressif-newlib-esp32-${TAGNAME}_GH0.tar.gz
XTENSA_OVERLAYS_TAGNAME=	4d8c98d
.endif

.if defined(XTENSA_OVERLAYS_TAGNAME)
GH_TUPLE+=	espressif:xtensa-overlays:${XTENSA_OVERLAYS_TAGNAME}:source104
EXTRACT_ONLY+=	espressif-xtensa-overlays-${XTENSA_OVERLAYS_TAGNAME}_GH0.tar.gz
.endif

PATCHDIR=		${MASTERDIR}/files/${FLAVOR}
XTENSA_ROOT_DIR=	${PORTNAME}-${FLAVOR}

GNU_CONFIGURE= yes
NO_MTREE=	yes
SUBDIR=		crosstool-NG
BINARY_ALIAS=	g++=${CXX} gcc=${CC} python=${PYTHON_VERSION}
BUILD_ENV=	LD_RUN_PATH=${PREFIX}/lib/${CC} \
		${MAKE_ENV:MPATH=*} \
		CT_JOBS=${MAKE_JOBS_NUMBER}

# these variables are automatically appended to crosstool.config at
# pre-configure. common variables should go into XTENSA_CT_CONFIG
XTENSA_CT_CONFIG+=	\
	CT_FORBID_DOWNLOAD=y \
	CT_PARALLEL_JOBS=${MAKE_JOBS_NUMBER}

# XXX CT_LOG_DEBUG is noisy. without this, however, ct-ng does not produce
# meaningful error messages, and one has to see build.log for the actual
# error.
XTENSA_CT_CONFIG+=	CT_LOG_DEBUG=y

.if defined(BATCH)
XTENSA_CT_CONFIG+=	CT_LOG_PROGRESS_BAR=n
.endif

# XXX ct-ng does not allow this to be defined in crosstool.config
BUILD_ENV+=	CT_ALLOW_BUILD_AS_ROOT_SURE=y

# XXX as configure in ncurses 6.2 breaks dynamic linker search path, subsequent
# execution of bash fails. this workaround is obtained from devel/ncurses
BUILD_ENV+=	cf_cv_ld_searchpath="${LOCALBASE}/lib /usr/lib /lib"

XTENSA_PLATFORMIO_TOOLCHAIN_OWNER=	espressif
.if ${PORTNAME} == xtensa-esp32-elf
XTENSA_PLATFORMIO_TOOLCHAIN_NAME=	toolchain-xtensa-esp32
.elif ${PORTNAME} == xtensa-esp32s2-elf
XTENSA_PLATFORMIO_TOOLCHAIN_NAME=	toolchain-xtensa-esp32s2
.elif ${PORTNAME} == xtensa-esp32s3-elf
XTENSA_PLATFORMIO_TOOLCHAIN_NAME=	toolchain-xtensa-esp32s3
.elif ${PORTNAME} == riscv32-esp-elf
XTENSA_PLATFORMIO_TOOLCHAIN_NAME=	toolchain-riscv32-esp
.endif
XTENSA_PLATFORMIO_TOOLCHAIN_VERSION=	${ESPRESSIF_GCC_VERSION}+${ESPRESSIF_VERSION}

post-extract:
	${MKDIR} ${BUILD_WRKSRC}/.build/tarballs
.for F in $(DISTFILES:N$(EXTRACT_ONLY))
	${LN} -s ${DISTDIR}/${F:C/:source[0-9]+$//} \
	    ${BUILD_WRKSRC}/.build/tarballs
.endfor
.if defined(XTENSA_OVERLAYS_TAGNAME)
	${RMDIR} ${BUILD_WRKSRC}/overlays
	${LN} -s ${WRKDIR}/xtensa-overlays-${XTENSA_OVERLAYS_TAGNAME} ${BUILD_WRKSRC}/overlays
.endif

pre-configure:
	@${REINPLACE_CMD} -e 's/\(GNU bash, version.*4\)/\1|5/' \
	    ${WRKSRC}/configure.ac
	${REINPLACE_CMD} \
	    -e 's|%%WRKDIR%%|${WRKDIR}|g' \
	    -e 's|%%ESPRESSIF_VERSION%%|${ESPRESSIF_VERSION}|g' \
		-e 's|%%PYTHON_VERSION%%|${PYTHON_VERSION}|g' \
		-e 's|%%TAGNAME%%|${TAGNAME}|g' \
		-e 's|%%XTENSA_GDB_VERSION%%|${XTENSA_GDB_VERSION}|g' \
	    ${WRKSRC}/samples/${PORTNAME}/crosstool.config
.if ${FLAVOR} == idf43 || ${FLAVOR} == idf44
	${REINPLACE_CMD} \
	    -e 's|%%ESPRESSIF_VERSION%%|${ESPRESSIF_VERSION}|g' \
	    ${WRKSRC}/maintainer/git-version-gen
.endif
	${ECHO} ${XTENSA_CT_CONFIG} | ${TR} '[[:space:]]' '\n' \
		>> ${WRKSRC}/samples/${PORTNAME}/crosstool.config

do-configure:
	cd ${BUILD_WRKSRC} && ./bootstrap
.if ${FLAVOR} == idf42
	${PRINTF} "#!/bin/sh\necho '${SUBDIR:tl}-${TAGNAME}'\n" > \
	    ${BUILD_WRKSRC}/version.sh
	${CHMOD} -w+x ${BUILD_WRKSRC}/version.sh
.endif
	cd ${BUILD_WRKSRC} && \
	    ${SETENV} GREP=${LOCALBASE}/bin/grep \
		EGREP="${LOCALBASE}/bin/egrep" \
		SED="${LOCALBASE}/bin/gsed" \
		AWK="${LOCALBASE}/bin/gawk" \
		./configure --enable-local --prefix=${PREFIX}
	cd ${BUILD_WRKSRC} && \
	    ${SETENV} -uMAKELEVEL -uMAKEFLAGS -u.MAKE.LEVEL.ENV ${MAKE_ENV} \
	    ${MAKE_CMD} ${MAKE_ARGS} install
	cd ${BUILD_WRKSRC} && \
	    ${SETENV} ${BUILD_ENV} PREFIX=${PREFIX} ./ct-ng ${PORTNAME}

pre-build:
.if ${FLAVOR} == idf42
	# obtained from math/gmp/files/patch-configure, fixes build on CURRENT
	${CP} ${PATCHDIR}/configure.patch ${WRKSRC}/packages/gmp/6.1.2/
.endif

	${RM} ${WRKSRC}/scripts/functions.orig \
		${WRKSRC}/samples/${PORTNAME}/crosstool.config.bak \
		${WRKSRC}/samples/${PORTNAME}/crosstool.config.orig

do-build:
	cd ${BUILD_WRKSRC} && ${SETENV} ${BUILD_ENV} ./ct-ng build

	${FIND} ${BUILD_WRKSRC}/builds/${PORTNAME} -type d | ${XARGS} ${CHMOD} +w
	${RM} ${BUILD_WRKSRC}/builds/${PORTNAME}/build.log.bz2 \
		${BUILD_WRKSRC}/builds/${PORTNAME}/lib/charset.alias
	${FIND} ${BUILD_WRKSRC}/builds/${PORTNAME} -type d | ${XARGS} ${CHMOD} -w

do-install:
	cd ${BUILD_WRKSRC}/builds && \
		${COPYTREE_BIN} ${PORTNAME} ${STAGEDIR}${PREFIX}
	${MV} ${STAGEDIR}${PREFIX}/${PORTNAME} ${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}
	# do NOT install ct-ng and its files. we just need binaries for the
	# PORTNAME, not ct-ng
	cd ${STAGEDIR}${PREFIX} && \
		${RM} -rf bin/ct-ng \
			libexec/crosstool-ng \
			share/crosstool-ng \
			share/doc/crosstool-ng \
			share/man/man1/ct-ng.1.gz \
			share/bash-completion
.if ${ESPRESSIF_GCC_VERSION} == 8.4.0
	@${STRIP_CMD} \
		${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/lib/libcc1.so.0.0.0 \
		${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/lib/gcc/${PORTNAME}/${ESPRESSIF_GCC_VERSION}/plugin/libcc1plugin.so.0.0.0 \
		${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/lib/gcc/${PORTNAME}/${ESPRESSIF_GCC_VERSION}/plugin/libcp1plugin.so.0.0.0 \
		${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/libexec/gcc/${PORTNAME}/${ESPRESSIF_GCC_VERSION}/plugin/gengtype
.endif
	# install metadata file for platformio
	${INSTALL_DATA} ${PATCHDIR}/piopm ${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/.piopm
	${REINPLACE_CMD} \
	    -e 's|%%XTENSA_PLATFORMIO_TOOLCHAIN_NAME%%|${XTENSA_PLATFORMIO_TOOLCHAIN_NAME}|' \
	    -e 's|%%XTENSA_PLATFORMIO_TOOLCHAIN_VERSION%%|${XTENSA_PLATFORMIO_TOOLCHAIN_VERSION}|' \
	    -e 's|%%XTENSA_PLATFORMIO_TOOLCHAIN_OWNER%%|${XTENSA_PLATFORMIO_TOOLCHAIN_OWNER}|' \
		${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/.piopm

.include <bsd.port.mk>
