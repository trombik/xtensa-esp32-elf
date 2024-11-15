PORTNAME=	esp-rom-elfs
DISTVERSION= 20241011
CATEGORIES=	devel
# XXX USE_GITHUB cannot be used because the repository does not contain the
# binaries.
MASTER_SITES=	https://github.com/espressif/esp-rom-elfs/releases/download/${DISTVERSION}/

MAINTAINER=	y@trombik.org
COMMENT=	ESP32 series ROM ELF files
WWW=	https://github.com/espressif/esp-rom-elfs

LICENSE=	APACHE20

WRKSRC=	${WRKDIR}
STRIP=

do-build:
	:

do-install:
	${INSTALL} -d ${STAGEDIR}${PREFIX}/${PORTNAME}
	(cd ${WRKDIR} && ${INSTALL_PROGRAM} *.elf ${STAGEDIR}${PREFIX}/${PORTNAME})

.include <bsd.port.mk>
