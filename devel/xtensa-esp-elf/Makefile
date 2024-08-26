# Created by: Craig Leres <leres@freebsd.org>

PORTNAME?=	xtensa-esp-elf
PORTVERSION=	${ESPRESSIF_VERSION:S/esp-//:S/_/./}
#PORTREVISION=	3
CATEGORIES=	devel
MASTER_SITES=
DISTFILES=
EXTRACT_ONLY=

MAINTAINER=	y@trombik.org
COMMENT?=	Espressif ESP32 toolchain
WWW=	https://github.com/trombik/xtensa-esp32-elf

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

FLAVORS=	idf53
FLAVOR?=	${FLAVORS:[1]}

# XXX use iconv:wchar_t.
# configure scripts picks -liconv during gcc build from converters/libiconv
# installed by dependencies. fixes error in stage-qa
# XXX use ncurses, which is required by gdb (libtinfow)
USES=		autoreconf:build bison gmake libtool python:3.8+ gettext-runtime iconv:wchar_t ncurses:port

.if ${FLAVOR} == idf53
ESPRESSIF_VERSION=	esp-13.2.0_20240530
ESPRESSIF_GCC_VERSION=	13.2.0
ESPRESSIF_GCC_TAG=	esp-13.2.0_20240530
ESPRESSIF_NEWLIB_TAG=	esp-4.3.0_20240530
ESPRESSIF_BINUTILS_TAG=	esp-2.41.0_20240530
XTENSA_OVERLAYS_TAGNAME=	dd1cf19
XTENSA_DYNCONFIG_TAGNAME=	c545876
XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_TAGNAME=	62776e9

MASTER_SITES+= \
		https://github.com/libexpat/libexpat/releases/download/R_2_4_1/:source1 \
		SF/expat/:source1 \
		GNU/gmp/:source2 \
		http://isl.gforge.inria.fr/:source3 \
		GNU/mpc/:source4 \
		http://www.mpfr.org/mpfr-4.2.1/:source5 \
		ftp://ftp.invisible-island.net/ncurses/:source6 \
		GNU/ncurses/:source6 \
		GNU/autoconf/:source7 \
		GNU/automake/:source8 \
		https://www.zlib.net/fossils/:source11 \
		https://github.com/facebook/zstd/releases/download/v1.5.5/:source12
DISTFILES+=	\
		expat-2.4.1.tar.gz:source1 \
		gmp-6.2.1.tar.xz:source2 \
		isl-0.26.tar.xz:source3 \
		mpc-1.2.1.tar.gz:source4 \
		mpfr-4.2.1.tar.xz:source5 \
		ncurses-6.2.tar.gz:source6 \
		autoconf-2.69.tar.gz:source7 \
		automake-1.16.1.tar.gz:source8 \
		zlib-1.2.13.tar.gz:source11 \
		zstd-1.5.5.tar.gz:source12

idf53_PLIST=	${MASTERDIR}/pkg-plist.${PORTNAME}-${FLAVOR}
idf53_PKGNAMESUFFIX=	-${FLAVOR}
.endif

GH_TUPLE+=	espressif:gcc:${ESPRESSIF_GCC_TAG}:source100 \
	espressif:binutils-gdb:${ESPRESSIF_BINUTILS_TAG}:source102 \
	espressif:newlib-esp32:${ESPRESSIF_NEWLIB_TAG}:source103 \
	espressif:crosstool-NG:${ESPRESSIF_VERSION}

DISTINFO_FILE=	${MASTERDIR}/distinfo.${PORTNAME}-${FLAVOR}
SUB_FILES=	pkg-message
SUB_LIST=	PREFIX=${PREFIX} PORTNAME=${PORTNAME} PKGNAMESUFFIX=${PKGNAMESUFFIX}

USE_GCC=	yes
USE_GITHUB=	yes
USE_LDCONFIG=	${PREFIX}/${PORTNAME}/libexec/gcc/${PORTNAME}/${ESPRESSIF_GCC_VERSION}
LDFLAGS+=	-L${LOCALBASE}/lib ${TINFO_LIB}


.if defined(XTENSA_OVERLAYS_TAGNAME)
GH_TUPLE+=	espressif:xtensa-overlays:${XTENSA_OVERLAYS_TAGNAME}:source104
EXTRACT_ONLY+=	espressif-xtensa-overlays-${XTENSA_OVERLAYS_TAGNAME}_GH0.tar.gz
.endif

.if defined(XTENSA_DYNCONFIG_TAGNAME)
GH_TUPLE+=	espressif:xtensa-dynconfig:${XTENSA_DYNCONFIG_TAGNAME}:source105
EXTRACT_ONLY+=	espressif-xtensa-dynconfig-${XTENSA_DYNCONFIG_TAGNAME}_GH0.tar.gz
.endif

.if defined(XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_TAGNAME)
GH_TUPLE+=	espressif:esp-toolchain-bin-wrappers:${XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_TAGNAME}:source106
EXTRACT_ONLY+=	espressif-esp-toolchain-bin-wrappers-${XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_TAGNAME}_GH0.tar.gz
.endif

# crosstool-NG supports custom location to archive files, but it also assumes
# that top directoy of an archive is same as its file name without suffix. due
# to this, arvhives from espressif github repositories must be extracted.
EXTRACT_ONLY+=	${DISTNAME}${EXTRACT_SUFX} \
	espressif-gcc-${ESPRESSIF_GCC_TAG}_GH0.tar.gz \
	espressif-binutils-gdb-${ESPRESSIF_BINUTILS_TAG}_GH0.tar.gz \
	espressif-newlib-esp32-${ESPRESSIF_NEWLIB_TAG}_GH0.tar.gz

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
XTENSA_PLATFORMIO_TOOLCHAIN_NAME=	toolchain-xtensa-esp
XTENSA_PLATFORMIO_TOOLCHAIN_VERSION=	${ESPRESSIF_GCC_VERSION}+${ESPRESSIF_VERSION:S/esp-//}

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
.if defined(XTENSA_DYNCONFIG_TAGNAME)
	${RMDIR} ${BUILD_WRKSRC}/xtensa-dynconfig
	${LN} -s ${WRKDIR}/xtensa-dynconfig-${XTENSA_DYNCONFIG_TAGNAME} ${BUILD_WRKSRC}/xtensa-dynconfig
.endif
.if defined(XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_TAGNAME)
	${RMDIR} ${BUILD_WRKSRC}/esp-toolchain-bin-wrappers
	${LN} -s ${WRKDIR}/esp-toolchain-bin-wrappers-${XTENSA_ESP_TOOLCHAIN_BIN_WRAPPERS_TAGNAME} ${BUILD_WRKSRC}/esp-toolchain-bin-wrappers
.endif

pre-configure:
	@${REINPLACE_CMD} -e 's/\(GNU bash, version.*4\)/\1|5/' \
	    ${WRKSRC}/configure.ac
	${REINPLACE_CMD} \
	    -e 's|%%ESPRESSIF_VERSION%%|${ESPRESSIF_VERSION}|g' \
	    ${WRKSRC}/maintainer/git-version-gen
	${REINPLACE_CMD} \
	    -e 's|%%WRKDIR%%|${WRKDIR}|g' \
	    -e 's|%%ESPRESSIF_VERSION%%|${ESPRESSIF_VERSION}|g' \
		-e 's|%%PYTHON_VERSION%%|${PYTHON_VERSION}|g' \
		-e 's|%%TAGNAME%%|${TAGNAME}|g' \
		-e 's|%%ESPRESSIF_NEWLIB_TAG%%|${ESPRESSIF_NEWLIB_TAG}|' \
		-e 's|%%ESPRESSIF_GCC_TAG%%|${ESPRESSIF_GCC_TAG}|' \
		-e 's|%%ESPRESSIF_BINUTILS_TAG%%|${ESPRESSIF_BINUTILS_TAG}|' \
	    ${WRKSRC}/samples/${PORTNAME}/crosstool.config
	${ECHO} ${XTENSA_CT_CONFIG} | ${TR} '[[:space:]]' '\n' \
		>> ${WRKSRC}/samples/${PORTNAME}/crosstool.config

do-configure:
	cd ${BUILD_WRKSRC} && ./bootstrap
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
	# install metadata files for platformio
	${INSTALL_DATA} ${PATCHDIR}/piopm ${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/.piopm
	${INSTALL_DATA} ${PATCHDIR}/package.json ${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/package.json
	${REINPLACE_CMD} \
	    -e 's|%%XTENSA_PLATFORMIO_TOOLCHAIN_NAME%%|${XTENSA_PLATFORMIO_TOOLCHAIN_NAME}|' \
	    -e 's|%%XTENSA_PLATFORMIO_TOOLCHAIN_VERSION%%|${XTENSA_PLATFORMIO_TOOLCHAIN_VERSION}|' \
	    -e 's|%%XTENSA_PLATFORMIO_TOOLCHAIN_OWNER%%|${XTENSA_PLATFORMIO_TOOLCHAIN_OWNER}|' \
		${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/.piopm \
		${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/package.json

.include <bsd.port.mk>
