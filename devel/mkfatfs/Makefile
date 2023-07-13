PORTNAME=	mkfatfs
DISTVERSION=	2.0.1
CATEGORIES=	devel
MASTER_SITES=	https://github.com/labplus-cn/mkfatfs/

MAINTAINER=	y@trombik.org
COMMENT=	Tools use for pack/unpack flash file system
WWW=	https://github.com/labplus-cn/mkfatfs

LICENSE=	MIT APACHE20
LICENSE_COMB=	multi

USES=	cmake
USE_GITHUB=	yes
GH_TUPLE=	labplus-cn:${PORTNAME}:v${DISTVERSION} \
	ARMmbed:mbed-littlefs:70aa179:littlefs/filesystem/littlefs

do-install:
	${INSTALL_PROGRAM} ${WRKDIR}/.build/mkfatfs ${STAGEDIR}${PREFIX}/bin

.include <bsd.port.mk>
