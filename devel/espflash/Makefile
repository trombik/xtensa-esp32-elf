PORTNAME=	espflash
PORTVERSION=	3.2.0
PORTREVISION=	0
DISTVERSIONPREFIX=	v
CATEGORIES=	devel
MASTER_SITES=

MAINTAINER=	y@trombik.org
COMMENT=	Serial flasher utility for Espressif SoCs

LICENSE=	MIT APACHE20
LICENSE_COMB=	dual

BUILD_DEPENDS=	rust-nightly>0:lang/rust-nightly \
	libssh2>0:security/libssh2 \
	libgit2>0:devel/libgit2
LIB_DEPENDS=	libcurl.so:ftp/curl

WWW=	https://github.com/esp-rs/espflash
USES=	cargo ssl
USE_GITHUB=	yes
GH_TUPLE=	esp-rs:${PORTNAME}:${DISTVERSIONPREFIX}${PORTVERSION}

# XXX disable CARGO_BUILDDEP because cargo.mk add lang/rust, not
# lang/rust-nightly, to BUILD_DEPENDS,
CARGO_BUILDDEP=	no
CARGO_INSTALL_PATH=	cargo-espflash espflash
CARGO_ENV=	LIBGIT2_NO_VENDOR=1

.include <bsd.port.mk>
