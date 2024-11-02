PORTNAME=	ldproxy
DISTVERSION=	0.3.2
DISTVERSIONPREFIX=	v
CATEGORIES=	devel
MASTER_SITES=

MAINTAINER=	y@trombik.org
COMMENT=	Tool to forward linker arguments to the actual linker executable

LICENSE=	MIT APACHE20
LICENSE_COMB=	dual

WWW=	https://github.com/esp-rs/embuild/
USES=	cargo
USE_GITHUB=	yes
GH_TUPLE=	esp-rs:embuild:${PORTNAME}-${DISTVERSIONPREFIX}${PORTVERSION}
CARGO_INSTALL_PATH=	${PORTNAME}

.include <bsd.port.mk>
