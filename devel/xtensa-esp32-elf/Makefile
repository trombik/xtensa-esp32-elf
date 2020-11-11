# Created by: Craig Leres <leres@freebsd.org>
# $FreeBSD$

PORTNAME=	xtensa-esp32-elf
PORTVERSION=	${ESPRESSIF_VERSION:S/esp-//:S/r/.r/}
#PORTREVISION=	1
CATEGORIES=	devel
MASTER_SITES= \
		https://github.com/libexpat/libexpat/releases/download/R_2_2_5/:source1 \
		SF/expat/:source1 \
		GNU/gmp/:source2 \
		http://isl.gforge.inria.fr/:source3 \
		GNU/mpc/:source4 \
		http://www.mpfr.org/mpfr-3.1.3/:source5 \
		GNU/mpfr/:source5 \
		ftp://ftp.invisible-island.net/ncurses/:source6 \
		GNU/ncurses/:source6 \
		GNU/autoconf/:source7 \
		GNU/automake/:source8
DISTNAME=	${PORTNAME}-${ESPRESSIF_VERSION}
DISTFILES=	\
		expat-2.2.5.tar.bz2:source1 \
		gmp-6.1.2.tar.xz:source2 \
		isl-0.19.tar.xz:source3 \
		mpc-1.1.0.tar.gz:source4 \
		mpfr-4.0.1.tar.xz:source5 \
		ncurses-6.1.tar.gz:source6 \
		autoconf-2.69.tar.gz:source7 \
		automake-1.16.1.tar.gz:source8
# crosstool-NG supports custom location to archive files, but it also assumes
# that top directoy of an archive is same as its file name without suffix. due
# to this, arvhives from espressif github repositories must be extracted.
EXTRACT_ONLY=	${DISTNAME}${EXTRACT_SUFX} \
	espressif-gcc-${ESPRESSIF_VERSION}_GH0.tar.gz \
	espressif-binutils-gdb-${ESPRESSIF_VERSION}-binutils_GH0.tar.gz \
	espressif-binutils-gdb-${ESPRESSIF_VERSION}-gdb_GH0.tar.gz \
	espressif-xtensa-overlays-${XTENSA_OVERLAYS_TAGNAME}_GH0.tar.gz \
	espressif-newlib-esp32-${ESPRESSIF_VERSION}_GH0.tar.gz

MAINTAINER=	leres@FreeBSD.org
COMMENT=	Espressif ESP32 toolchain

LICENSE=	GPLv2 LGPL21
LICENSE_COMB=	multi

BROKEN_aarch64=		fails to configure: cannot compute suffix of object files: cannot compile
BROKEN_armv6=		fails to build: failed in step 'Installing pass-2 core C gcc compiler'
BROKEN_armv7=		fails to build: failed in step 'Installing pass-2 core C gcc compiler'

BUILD_DEPENDS=	bash:shells/bash \
		gawk:lang/gawk \
		git:devel/git \
		gpatch:devel/patch \
		${LOCALBASE}/bin/grep:textproc/gnugrep \
		gperf:devel/gperf \
		gsed:textproc/gsed \
		help2man:misc/help2man \
		makeinfo:print/texinfo \
		wget:ftp/wget

USES=		autoreconf:build bison gmake libtool python:3.5+ iconv gettext-runtime
USE_GCC=	7+
USE_GITHUB=	yes
USE_LDCONFIG=	${PREFIX}/${PORTNAME}/libexec/gcc/${PORTNAME}/8.2.0

# XXX the upstream versioning does not match one of the ports
ESPRESSIF_VERSION=	esp-2020r3

TAGNAME=	${ESPRESSIF_VERSION}
XTENSA_OVERLAYS_TAGNAME=	4d8c98dc

GH_TUPLE=	espressif:gcc:${TAGNAME}:source100 \
	espressif:binutils-gdb:${TAGNAME}-gdb:source101 \
	espressif:binutils-gdb:${TAGNAME}-binutils:source102 \
	espressif:newlib-esp32:${TAGNAME}:source103 \
	espressif:xtensa-overlays:${XTENSA_OVERLAYS_TAGNAME}:source104 \
	espressif:crosstool-NG:${TAGNAME}

GNU_CONFIGURE= yes
NO_MTREE=	yes
SUBDIR=		crosstool-NG
BINARY_ALIAS=	g++=${CXX} gcc=${CC} python=${PYTHON_VERSION}
BUILD_ENV=	CT_ALLOW_BUILD_AS_ROOT_SURE=1 \
		LD_RUN_PATH=${PREFIX}/lib/${CC} \
		${MAKE_ENV:MPATH=*}

.if defined(BATCH)
CT_LOG_PROGRESS_BAR=	n
.else
CT_LOG_PROGRESS_BAR=	y
.endif

post-extract:
	${RMDIR} ${BUILD_WRKSRC}/overlays
	${LN} -s ${WRKDIR}/xtensa-overlays-${XTENSA_OVERLAYS_TAGNAME} ${BUILD_WRKSRC}/overlays
	${MKDIR} ${BUILD_WRKSRC}/.build/tarballs
#.for F in $(DISTFILES:N$(EXTRACT_ONLY))
.for F in $(DISTFILES)
	${LN} -s ${DISTDIR}/${F:C/:source[0-9]+$//} \
	    ${BUILD_WRKSRC}/.build/tarballs
.endfor

pre-configure:
	@${REINPLACE_CMD} -e 's/\(GNU bash, version.*4\)/\1|5/' \
	    ${WRKSRC}/configure.ac
	@${REINPLACE_CMD} -e 's|%%FILESDIR%%|${FILESDIR}|g' \
	    -e 's|%%WRKDIR%%|${WRKDIR}|g' \
	    -e 's|%%ESPRESSIF_VERSION%%|${ESPRESSIF_VERSION}|g' \
	    -e 's|%%CT_LOG_PROGRESS_BAR%%|${CT_LOG_PROGRESS_BAR}|g' \
	    ${WRKSRC}/samples/xtensa-esp32-elf/crosstool.config

do-configure:
	cd ${BUILD_WRKSRC} && ./bootstrap
	${PRINTF} "#!/bin/sh\necho '${SUBDIR:tl}-${TAGNAME}'\n" > \
	    ${BUILD_WRKSRC}/version.sh
	${CHMOD} -w+x ${BUILD_WRKSRC}/version.sh
	cd ${BUILD_WRKSRC} && \
	    ${SETENV} GREP=${LOCALBASE}/bin/grep EGREP="${LOCALBASE}/bin/egrep" SED="${LOCALBASE}/bin/gsed" AWK="${LOCALBASE}/bin/gawk" ./configure --enable-local --prefix=${PREFIX}
	cd ${BUILD_WRKSRC} && \
	    ${SETENV} -uMAKELEVEL -uMAKEFLAGS -u.MAKE.LEVEL.ENV ${MAKE_ENV} \
	    ${MAKE_CMD} ${MAKE_ARGS} install-strip && \
	    ${SETENV} ${BUILD_ENV} PREFIX=${PREFIX} ./ct-ng ${PORTNAME}

pre-build:
	# obtained from math/gmp/files/patch-configure, fixes build on CURRENT
	${CP} ${FILESDIR}/configure.patch ${WRKSRC}/packages/gmp/6.1.2/
	${RM} ${WRKSRC}/scripts/functions.orig \
		${WRKSRC}/samples/xtensa-esp32-elf/crosstool.config.bak \
		${WRKSRC}/samples/xtensa-esp32-elf/crosstool.config.orig

do-build:
	cd ${BUILD_WRKSRC} && ${SETENV} ${BUILD_ENV} ./ct-ng build

	${FIND} ${BUILD_WRKSRC}/builds/${PORTNAME} -type d | ${XARGS} ${CHMOD} +w
	${RM} ${BUILD_WRKSRC}/builds/${PORTNAME}/build.log.bz2 \
		${BUILD_WRKSRC}/builds/${PORTNAME}/lib/charset.alias

	@${STRIP_CMD} \
		${BUILD_WRKSRC}/builds/${PORTNAME}/lib/libcc1.so.0.0.0 \
		${BUILD_WRKSRC}/builds/${PORTNAME}/lib/gcc/xtensa-esp32-elf/8.4.0/plugin/libcc1plugin.so.0.0.0 \
		${BUILD_WRKSRC}/builds/${PORTNAME}/libexec/gcc/xtensa-esp32-elf/8.4.0/plugin/gengtype
	${FIND} ${BUILD_WRKSRC}/builds/${PORTNAME} -type d | ${XARGS} ${CHMOD} -w

do-install:
	cd ${BUILD_WRKSRC}/builds && \
		${COPYTREE_BIN} ${PORTNAME} ${STAGEDIR}${PREFIX}

.include <bsd.port.mk>
