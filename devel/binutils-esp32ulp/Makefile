PORTNAME=	binutils-${ESPRESSIF_CHIP}ulp
PORTVERSION=	${ESPRESSIF_VERSION:S/-esp-/./}
PORTREVISION=	1
CATEGORIES=	devel
MASTER_SITES=	#

MAINTAINER=	y@trombik.org
COMMENT=	Binutils fork with support for the ${ESPRESSIF_CHIP} ULP co-processor

LICENSE=	GPLv2
LICENSE_FILE=	${WRKSRC}/COPYING

USES=	bison cpe gmake tar:xz compiler:env

# see https://github.com/espressif/binutils-esp32ulp/releases
ESPRESSIF_VERSION=	2.28.51-esp-20191205
.if !defined(ESPRESSIF_CHIP)
ESPRESSIF_CHIP=	esp32
.endif

USE_GITHUB=	yes
USE_GCC=	yes
GH_TUPLE=	espressif:binutils-esp32ulp:v${ESPRESSIF_VERSION}

# XXX NOT GNU_CONFIGURE because bsd.port.mk replaces config.sub with its own
# one in which esp32ulp is not included.
HAS_CONFIGURE=	yes
ESPRESSIF_TARGET=	${ESPRESSIF_CHIP}ulp-elf
ESPRESSIF_MANDIR=	${PREFIX}/${PORTNAME}/share/man
MANDIRS+=	${ESPRESSIF_MANDIR}
PLATFORMIO_TOOLCHAIN_NAME=	toolchain-esp32ulp
PLATFORMIO_TOOLCHAIN_VERSION=	1.22851.0

# see https://github.com/espressif/binutils-esp32ulp/blob/master/.gitlab-ci.yml
ESPRESSIF_CONFIGURE_ARGS=	\
	--target=${ESPRESSIF_TARGET} \
	--disable-doc --disable-gdb --disable-libdecnumber --disable-readline --disable-sim
CONFIGURE_ARGS+=	\
	${ESPRESSIF_CONFIGURE_ARGS} \
	--prefix=${PREFIX}/${PORTNAME} \
	--mandir=${ESPRESSIF_MANDIR} \
	--disable-nls \
	--disable-werror
CONFIGURE_ENV+=	\
	YACC="yacc"
PLIST_SUB+=	PORTNAME=${PORTNAME} ESPRESSIF_CHIP=${ESPRESSIF_CHIP}
INSTALL_TARGET=	install-strip

.include <bsd.port.pre.mk>

pre-configure:
	# see .set_displayed_version in .gitlab-ci.yml
	${REINPLACE_CMD} -e 's|%%ESPRESSIF_VERSION%%|${ESPRESSIF_VERSION}|g' \
		${WRKSRC}/bfd/Makefile.in
post-configure:
	${ECHO} "MAKEINFO = :" >> ${WRKSRC}/Makefile

post-install:
	# install metadata file for platformio
	${INSTALL_DATA} ${PATCHDIR}/piopm ${STAGEDIR}${PREFIX}/${PORTNAME}/.piopm
	${REINPLACE_CMD} \
	    -e 's|%%PLATFORMIO_TOOLCHAIN_NAME%%|${PLATFORMIO_TOOLCHAIN_NAME}|' \
	    -e 's|%%PLATFORMIO_TOOLCHAIN_VERSION%%|${PLATFORMIO_TOOLCHAIN_VERSION}|' \
		${STAGEDIR}${PREFIX}/${PORTNAME}/.piopm

.include <bsd.port.post.mk>
