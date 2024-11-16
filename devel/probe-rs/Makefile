PORTNAME=	probe-rs
DISTVERSION=	0.24.0
CATEGORIES=	devel
MASTER_SITES=

MAINTAINER=	y@trombik.org
COMMENT=	Debugging toolset and library for embedded devices

LICENSE=	MIT APACHE20
LICENSE_COMB=	dual

BROKEN=	dependencies do not support FreeBSD (nusb)

WWW=	https://github.com/probe-rs/probe-rs
USES=	cargo
USE_GITHUB=	yes
GH_TUPLE=	probe-rs:${PORTNAME}:v${DISTVERSION}
CARGO_INSTALL_PATH=	${PORTNAME}

# a helper target to update distinfo
updatecrates: extract
	${MAKE} cargo-crates > Makefile.crates
	${MAKE} makesum

.include <bsd.port.mk>
