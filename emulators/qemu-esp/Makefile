PORTNAME=	qemu-esp
PORTVERSION=	${ESP_QEMU_VERSION}.${ESP_QEMU_SNAPDATE}
CATEGORIES=	emulators devel

MAINTAINER=	y@trombik.org
COMMENT?=	QEMU emulator with espressif xtensa and riscv32 support
WWW=		https://github.com/espressif/qemu

BUILD_DEPENDS=	bash:shells/bash
LIB_DEPENDS=	libslirp.so:net/libslirp
LIB_DEPENDS+=	libfdt.so:sysutils/dtc \
		libinotify.so:devel/libinotify \
		libslirp.so:net/libslirp \
		libgcrypt.so:security/libgcrypt

LICENSE=	GPLv2

# build workflow: https://github.com/espressif/qemu/blob/esp-develop/.github/workflows/build.yml
# pre-requisites: https://github.com/espressif/qemu/blob/esp-develop/.github/workflows/scripts/prerequisites-old.sh
# configure: https://github.com/espressif/qemu/blob/esp-develop/.github/workflows/scripts/configure-native.sh

# see https://github.com/espressif/qemu/releases
ESP_QEMU_VERSION=	9.0.0
ESP_QEMU_SNAPDATE=	20240606
ESP_VERSION=	${ESP_QEMU_VERSION}-${ESP_QEMU_SNAPDATE}
ESP_RELEASE_TAG=	esp-develop-${ESP_VERSION}
ESP_PREFIX=	${PREFIX}/${PORTNAME}
ESP_TARGET=	xtensa-softmmu riscv32-softmmu

USE_GITHUB=	yes
GH_ACCOUNT=	espressif
GH_PROJECT=	qemu
GH_TAGNAME=	${ESP_RELEASE_TAG}
PLIST_SUB+=	PORTNAME=${PORTNAME}

# see subprojects/*.wrap
GH_TUPLE=	\
	qemu:keycodemapdb:f5772a62ec52591ff6870b7e8ef32482371f22c6:keycodemapdb/subprojects/keycodemapdb \
	qemu:dtc:b6910bec11614980a21e46fbccc35934b671bd81:dtc/subprojects/dtc \
	nutanix:libvfio-user:0b28d205572c80b568a1003db2c8f37ca333e4d7:libvfio/subprojects/libvfio-user \
	qemu:meson:18427adbf21909f66a307a54ba4c47fd91e18fba:meson/meson \
	qemu:berkeley-softfloat-3:b64af41c3276f97f0e181920400ee056b9c88037:berkeleysoftfloat3/subprojects/berkeley-softfloat-3 \
	qemu:berkeley-testfloat-3:e7af9751d9f9fd3b47911f51a5cfd08af256a9ab:berkeleytestfloat3/subprojects/berkeley-testfloat-3

ONLY_FOR_ARCHS=	amd64
HAS_CONFIGURE=	yes
USES=		cpe gmake gnome ninja perl5 pkgconfig python:build shebangfix tar:xz iconv:wchar_t sdl xorg
USE_GNOME=	gdkpixbuf2
USE_SDL=	sdl2
USE_XORG=	x11 xext
X11_CONFIGURE_ENABLE=	sdl

#SHEBANG_FILES=	scripts/xml-preprocess.py
USE_GNOME=	glib20
USE_PERL5=	build

# see https://github.com/espressif/qemu/blob/esp-develop/.github/workflows/scripts/configure-native.sh
CONFIGURE_ARGS=	--enable-gcrypt \
				--enable-sdl \
				--enable-slirp \
				--enable-stack-protector \
				--target-list="${ESP_TARGET}" \
				--with-pkgversion="${ESP_VERSION}" \
				--without-default-features

# see emulators/qemu/Makefile
CONFIGURE_ARGS+=	--cc=${CC} \
			--disable-kvm \
			--disable-linux-aio \
			--disable-linux-user \
			--disable-xen \
			--extra-cflags=-I${WRKSRC}\ -I${LOCALBASE}/include\ -DPREFIX=\\\"\"${ESP_PREFIX}\\\"\" \
			--extra-ldflags=-L${LOCALBASE}/lib \
			--extra-ldflags=-L/usr/lib \
			--localstatedir=/var \
			--mandir=${ESP_PREFIX}/share/man \
			--prefix=${ESP_PREFIX} \
			--python=${PYTHON_CMD} \
			--enable-fdt=system

CFLAGS:=	${CFLAGS:C/-fno-tree-vrp//}
WITHOUT_CPU_CFLAGS=	yes #to avoid problems with register allocation

.include <bsd.port.options.mk>

.if ${ARCH} == amd64
MAKE_ARGS+=	ARCH=x86_64
.endif

post-extract:
	${CP} ${WRKSRC}/subprojects/packagefiles/berkeley-softfloat-3/* \
		${WRKSRC}/subprojects/berkeley-softfloat-3/
	${CP} ${WRKSRC}/subprojects/packagefiles/berkeley-testfloat-3/* \
		${WRKSRC}/subprojects/berkeley-testfloat-3/

do-build:
	cd ${WRKSRC} && ${SETENVI} ${WRK_ENV} ${GMAKE} -j${MAKE_JOBS_NUMBER}

do-install:
	cd ${WRKSRC} && ${SETENVI} ${WRK_ENV} DESTDIR=${STAGEDIR} ${GMAKE} install

post-install:
	@${STRIP_CMD} ${STAGEDIR}${ESP_PREFIX}/bin/qemu-*

.include <bsd.port.mk>
