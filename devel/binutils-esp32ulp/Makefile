PORTNAME=	binutils-${ESPRESSIF_CHIP}ulp
PORTVERSION=	${ESPRESSIF_VERSION:S/-esp-/./}
CATEGORIES=	devel
MASTER_SITES=	#

MAINTAINER=	y@trombik.org
COMMENT=	Binutils fork with support for the ESP32 ULP co-processor

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

post-configure:
	${ECHO} "MAKEINFO = :" >> ${WRKSRC}/Makefile

.include <bsd.port.post.mk>