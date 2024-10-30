PORTNAME=	wokwi-server
DISTVERSION=	0.2.0
DISTVERSIONPREFIX=	v
CATEGORIES=	emulators
MASTER_SITES=

MAINTAINER=	y@trombik.org
COMMENT=	CLI tool for launching a wokwi instance

LICENSE=	MIT APACHE20
LICENSE_COMB=	dual

BUILD_DEPENDS=	rust-nightly>0:lang/rust-nightly

WWW=	https://github.com/MabezDev/wokwi-server
USES=	cargo
USE_GITHUB=	yes
GH_TUPLE=	MabezDev:${PORTNAME}:${DISTVERSIONPREFIX}${PORTVERSION}

# XXX disable CARGO_BUILDDEP because cargo.mk add lang/rust, not
# lang/rust-nightly, to BUILD_DEPENDS,
CARGO_BUILDDEP=	no

.include <bsd.port.mk>
