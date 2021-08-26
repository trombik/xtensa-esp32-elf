# Created by: Craig Leres <leres@freebsd.org>

PORTNAME=	xtensa-esp32-elf
PORTVERSION=	${ESPRESSIF_VERSION:S/esp-//:S/crosstool-ng-//:S/r/.r/}
CATEGORIES=	devel
MASTER_SITES=
DISTFILES=
EXTRACT_ONLY=

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

DISTNAME=	${PORTNAME}-${ESPRESSIF_VERSION}
USES=		autoreconf:build bison gmake libtool python:3.5+ gettext-runtime iconv
FLAVORS=	idf4 idf3
FLAVOR?=	${FLAVORS:[1]}
.if ${FLAVOR} == idf4
MASTER_SITES+= \
		https://github.com/libexpat/libexpat/releases/download/R_2_2_9/:source1 \
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
		expat-2.2.9.tar.gz:source1 \
		gmp-6.2.0.tar.xz:source2 \
		isl-0.19.tar.xz:source3 \
		mpc-1.1.0.tar.gz:source4 \
		mpfr-4.0.2.tar.xz:source5 \
		ncurses-6.2.tar.gz:source6 \
		autoconf-2.69.tar.gz:source7 \
		automake-1.16.1.tar.gz:source8 \
		zlib-1.2.11.tar.gz:source11
.elif ${FLAVOR} == idf3
MASTER_SITES+=	SOURCEWARE/binutils/releases/binutils:source1 \
		GNU/binutils:source1 \
		https://github.com/libexpat/libexpat/releases/download/R_2_1_0/:source2 \
		SF/expat/expat/2.1.0:source2 \
		GCC/releases/gcc-5.2.0:source3 \
		GNU/gdb:source4 \
		GNU/gmp:source5 \
		http://isl.gforge.inria.fr/:source6 \
		GNU/mpc:source7 \
		http://www.mpfr.org/mpfr-3.1.3/:source8 \
		GNU/mpfr:source8 \
		ftp://ftp.invisible-island.net/ncurses/:source9 \
		GNU/ncurses:source9 \
		SOURCEWARE/newlib:source10 \
		ftp://sources.redhat.com/pub/newlib/:source10
DISTFILES+=	binutils-2.25.1.tar.bz2:source1 \
		expat-2.1.0.tar.gz:source2 \
		gcc-5.2.0.tar.bz2:source3 \
		gdb-7.10.tar.xz:source4 \
		gmp-6.0.0a.tar.xz:source5 \
		isl-0.14.tar.xz:source6 \
		mpc-1.0.3.tar.gz:source7 \
		mpfr-3.1.3.tar.xz:source8 \
		ncurses-6.0.tar.gz:source9 \
		newlib-2.2.0.tar.gz:source10
.endif

idf4_PLIST=	${.CURDIR}/pkg-plist.${FLAVOR}
idf3_PLIST=	${.CURDIR}/pkg-plist.${FLAVOR}
idf4_PKGNAMESUFFIX=	-idf4
idf3_PKGNAMESUFFIX=	-idf3
DISTINFO_FILE=	${.CURDIR}/distinfo.${FLAVOR}
SUB_FILES=	pkg-message
SUB_LIST=	PREFIX=${PREFIX} PORTNAME=${PORTNAME} PKGNAMESUFFIX=${PKGNAMESUFFIX}

USE_GCC=	9+
USE_GITHUB=	yes
USE_LDCONFIG=	${PREFIX}/${PORTNAME}/libexec/gcc/${PORTNAME}/8.2.0

.if ${FLAVOR} == idf4
# XXX the upstream versioning does not match one of the ports
ESPRESSIF_VERSION=	esp-2021r1
XTENSA_OVERLAYS_TAGNAME=	a5ab689
TAGNAME=	${ESPRESSIF_VERSION}
GH_TUPLE=	espressif:gcc:${TAGNAME}:source100 \
	espressif:binutils-gdb:${TAGNAME}-gdb81:source101 \
	espressif:binutils-gdb:${TAGNAME}-binutils:source102 \
	espressif:newlib-esp32:${TAGNAME}:source103 \
	espressif:xtensa-overlays:${XTENSA_OVERLAYS_TAGNAME}:source104 \
	espressif:crosstool-NG:${TAGNAME}

# crosstool-NG supports custom location to archive files, but it also assumes
# that top directoy of an archive is same as its file name without suffix. due
# to this, arvhives from espressif github repositories must be extracted.
EXTRACT_ONLY+=	${DISTNAME}${EXTRACT_SUFX} \
	espressif-gcc-${ESPRESSIF_VERSION}_GH0.tar.gz \
	espressif-binutils-gdb-${ESPRESSIF_VERSION}-binutils_GH0.tar.gz \
	espressif-binutils-gdb-${ESPRESSIF_VERSION}-gdb81_GH0.tar.gz \
	espressif-xtensa-overlays-${XTENSA_OVERLAYS_TAGNAME}_GH0.tar.gz \
	espressif-newlib-esp32-${ESPRESSIF_VERSION}_GH0.tar.gz

.elif ${FLAVOR} == idf3

# the latest commit in espressif/crosstools-NG xtensa-1.22.x branch
# this should match the supported version in arduino-esp32. see:
# https://github.com/espressif/arduino-esp32/blob/gh-pages/package_esp32_index.json
TAGNAME=	c752ad5

# the old branch has no consistent version number scheme. modify
# ESPRESSIF_VERSION so that the version number looks similar to packages for
# other platforms and also compatible with PORTVERSION.
#
# as it's 1.22.0-97-gc752ad5-5.2.0 at the time of this writing,
# ESPRESSIF_VERSION_IDF3 is 97.
ESPRESSIF_VERSION_IDF3=	97
ESPRESSIF_VERSION=	crosstool-ng-1.22.0.${ESPRESSIF_VERSION_IDF3}.g${TAGNAME}
XTENSA_OVERLAYS_TAGNAME=	eb39108
GH_TUPLE=	espressif:crosstool-NG:${TAGNAME}
EXTRACT_ONLY+=	${DISTNAME}${EXTRACT_SUFX}
TARBALLS=       ${BUILD_WRKSRC}/.build/tarballs
.endif

PATCHDIR=		${MASTERDIR}/files/${FLAVOR}
XTENSA_ROOT_DIR=	${PORTNAME}-${FLAVOR}

GNU_CONFIGURE= yes
NO_MTREE=	yes
SUBDIR=		crosstool-NG
BINARY_ALIAS=	g++=${CXX} gcc=${CC} python=${PYTHON_VERSION}
BUILD_ENV=	CT_ALLOW_BUILD_AS_ROOT_SURE=1 \
		LD_RUN_PATH=${PREFIX}/lib/${CC} \
		CT_FORBID_DOWNLOAD=y \
		${MAKE_ENV:MPATH=*}

# XXX CT_LOG_DEBUG is noisy. without this, however, ct-ng does not produce
# meaningful error messages, and one has to see build.log for the actual
# error.
XTENSA_LOG_LEVEL?=	CT_LOG_DEBUG=y

.if ${FLAVOR} == idf4
# XXX as configure in ncurses 6.2 breaks dynamic linker search path, subsequent
# execution of bash fails. this workaround is obtained from devel/ncurses
BUILD_ENV+=	cf_cv_ld_searchpath="${LOCALBASE}/lib /usr/lib /lib"
.endif

.if defined(BATCH)
CT_LOG_PROGRESS_BAR=	n
.else
CT_LOG_PROGRESS_BAR=	y
.endif

post-extract:
.if ${FLAVOR} == idf4
	${RMDIR} ${BUILD_WRKSRC}/overlays
	${LN} -s ${WRKDIR}/xtensa-overlays-${XTENSA_OVERLAYS_TAGNAME} ${BUILD_WRKSRC}/overlays
	${MKDIR} ${BUILD_WRKSRC}/.build/tarballs
.elif ${FLAVOR} == idf3
	${MKDIR} ${TARBALLS}
	${MKDIR} ${WRKSRC}/local-patches/gdb/7.10
	${CP} ${PATCHDIR}/0001-gdb-7.12.1.patch ${WRKSRC}/local-patches/gdb/7.10
.endif
.for F in $(DISTFILES:N$(EXTRACT_ONLY))
	${LN} -s ${DISTDIR}/${F:C/:source[0-9]+$//} \
	    ${BUILD_WRKSRC}/.build/tarballs
.endfor

pre-configure:
	@${REINPLACE_CMD} -e 's/\(GNU bash, version.*4\)/\1|5/' \
	    ${WRKSRC}/configure.ac
.if ${FLAVOR} == idf4
	${REINPLACE_CMD} \
	    -e 's|%%WRKDIR%%|${WRKDIR}|g' \
	    -e 's|%%ESPRESSIF_VERSION%%|${ESPRESSIF_VERSION}|g' \
		-e 's|%%PYTHON_VERSION%%|${PYTHON_VERSION}|g' \
	    ${WRKSRC}/samples/${PORTNAME}/crosstool.config
.endif
	${REINPLACE_CMD} \
	    -e 's|%%CT_LOG_PROGRESS_BAR%%|${CT_LOG_PROGRESS_BAR}|g' \
		-e 's|%%MAKE_JOBS_NUMBER%%|${MAKE_JOBS_NUMBER}|g' \
		-e 's|%%XTENSA_LOG_LEVEL%%|${XTENSA_LOG_LEVEL}|g' \
	    ${WRKSRC}/samples/${PORTNAME}/crosstool.config

do-configure:
	cd ${BUILD_WRKSRC} && ./bootstrap
	${PRINTF} "#!/bin/sh\necho '${SUBDIR:tl}-${TAGNAME}'\n" > \
	    ${BUILD_WRKSRC}/version.sh
	${CHMOD} -w+x ${BUILD_WRKSRC}/version.sh
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
.if ${FLAVOR} == idf4
	# obtained from math/gmp/files/patch-configure, fixes build on CURRENT
	${CP} ${FILESDIR}/configure.patch ${WRKSRC}/packages/gmp/6.1.2/
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
.if ${FLAVOR} == idf4
	@${STRIP_CMD} \
		${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/lib/libcc1.so.0.0.0 \
		${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/lib/gcc/xtensa-esp32-elf/8.4.0/plugin/libcp1plugin.so.0.0.0 \
		${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/libexec/gcc/xtensa-esp32-elf/8.4.0/plugin/gengtype
.elif ${FLAVOR} == idf3
	@${STRIP_CMD} \
		${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/libexec/gcc/xtensa-esp32-elf/5.2.0/plugin/gengtype
.endif
	# install metadata file for platformio
	${INSTALL_DATA} ${PATCHDIR}/piopm ${STAGEDIR}${PREFIX}/${XTENSA_ROOT_DIR}/.piopm

.include <bsd.port.mk>
