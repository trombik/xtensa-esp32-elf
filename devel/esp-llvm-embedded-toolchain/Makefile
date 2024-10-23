PORTNAME?=	esp-llvm-embedded-toolchain
PORTVERSION=	${ESP_LLVM_VERSION}.${ESP_SNAPDATE}
CATEGORIES=	devel
DISTFILES=

MAINTAINER=	y@trombik.org
COMMENT?=	LLVM and Clang with support the RISC-V and Xtensa architecture (clang)
WWW=		https://github.com/espressif/llvm-project

# XXX the port is beta quality.

# the port requires gcc toolchains.
# XXX USES+=gmake cannot be used because of USES+=ninja
BUILD_DEPENDS=	${LOCALBASE}/riscv32-esp-elf-${ESP_IDF_FLAVOR}/bin/riscv32-esp-elf-gcc:devel/riscv32-esp-elf@${ESP_IDF_FLAVOR} \
				${LOCALBASE}/xtensa-esp-elf-${ESP_IDF_FLAVOR}/bin/xtensa-esp-elf-gcc:devel/xtensa-esp-elf@${ESP_IDF_FLAVOR} \
				gmake>=4.4.1:devel/gmake
LIB_DEPENDS=	libzstd.so:archivers/zstd

USES=		cmake compiler:c++17-lang cpe shebangfix ninja makeinfo python
USE_GCC=	yes
USE_GITHUB=	yes

GH_TUPLE=	espressif:esp-llvm-embedded-toolchain:esp-${ESP_LLVM_VERSION}_${ESP_SNAPDATE}

ESP_TARGET?=	llvm-toolchain
.if ${PORTNAME} == esp-llvm-embedded-toolchain

PKGNAMESUFFIX=	-clang
LIB_DEPENDS+=	libdebuginfod.so:devel/elfutils \
	libxml2.so:textproc/libxml2

.elif ${PORTNAME} == esp-llvm-embedded-toolchain-libs-clang

PKGNAMESUFFIX=

.endif
INSTALL_TARGET=	install-${ESP_TARGET}
PLIST=	${MASTERDIR}/pkg-plist.${ESP_TARGET}

# see versions.json. ESP_GH_TUPLE is a list of dependencies from espressif's
# GitHub repositories. in versions.json, some ref is `main` or `master`.
# checkout the commit SHAs in these branches and use them here.
ESP_REF_LLVM_PROJECT=	esp-18.1.2_20240912
ESP_REF_BINUTILS_GDB=	esp-2.41.0_20240305
ESP_REF_XTENSA_OVERLAYS=	dd1cf19
ESP_REF_NEWLIB_ESP32=	esp-4.3.0_20240322
ESP_REF_PICOLIBC=	b955d78
ESP_GH_TUPLE= espressif:llvm-project:${ESP_REF_LLVM_PROJECT}:llvmproject \
	espressif:binutils-gdb:${ESP_REF_BINUTILS_GDB}:binutils \
	espressif:xtensa-overlays:${ESP_REF_XTENSA_OVERLAYS}:xtensa_overlays \
	espressif:newlib-esp32:${ESP_REF_NEWLIB_ESP32}:newlib \
	espressif:picolibc:${ESP_REF_PICOLIBC}:picolibc
GH_TUPLE+=	${ESP_GH_TUPLE}

# see https://github.com/espressif/esp-llvm-embedded-toolchain/tags
# in the form of ${ESP_LLVM_VERSION}_${ESP_SNAPDATE}
ESP_LLVM_VERSION=	18.1.2
ESP_SNAPDATE=	20240912

# everything is under a single directory, ${ESP_PREFIX}.
ESP_PREFIX=	${PREFIX}/${PORTNAME}

# the build process does not honor ${TMPDIR} but use '/tmp". in some cases
# ${TMPDIR} can be small. use 'tmp' under ${WRKSRC}, which should have a
# plenty of space.
ESP_TMPDIR?=	${WRKSRC}/tmp

# the flavor of gcc toolchains.
ESP_IDF_FLAVOR=	idf53

# TODO document reference
ESP_GNU_TOOLCHAIN_VER=	13.2.0_20240305
ESP_ARCH=	${ARCH:S/amd64/x86_64/}

# see .gitlab-ci.yml and .github/workflows/release-binaries.yml in
# espressif/llvm-project
CMAKE_ARGS=	\
	-DFETCHCONTENT_QUIET=OFF \
	-DESP_GNU_TOOLCHAIN_VER=${ESP_GNU_TOOLCHAIN_VER} \
	-DCPACK_ARCHIVE_THREADS=0 \
	-DUSE_LIBC=newlib \
	-DUSE_LIBCXX="libstdcxx" \
	-DUSE_RTLIB="compiler-rt;libgcc" \
	-DUSE_BINUTILS=ON  \
	-DESP_TOOLCHAIN=ON \
	-DHOST_TRIPLE=x86_64-unknown-freebsd \
	-DLLVM_TOOLCHAIN_ENABLED_TARGETS="RISCV;Xtensa"  \
	-DESP_TOOLCHAIN_VER=${ESP_LLVM_VERSION}_${ESP_SNAPDATE} \
	--install-prefix ${STAGEDIR}${ESP_PREFIX} \
	-DMAKE_JOBS_NUM=${MAKE_JOBS_NUMBER}

# our own CMAKE_ARGS
CMAKE_ARGS+=	\
	-DCLANG_REPOSITORY_STRING=${WWW}

# TODO are gcc13 and g++13 necessary?
BINARY_ALIAS=	gcc13=${CC} g++13=${CXX} \
				${ESP_ARCH}-unknown-freebsd-gcc=${ESP_ARCH}-portbld-freebsd${OSREL}-${CC} \
				${ESP_ARCH}-unknown-freebsd-g++=${ESP_ARCH}-portbld-freebsd${OSREL}-${CXX} \
				gcc=${ESP_ARCH}-portbld-freebsd${OSREL}-${CC} \
				make=gmake

# include bin of gcc toolchains so that cmake can find gcc binaries.
PATH:=	${LOCALBASE}/riscv32-esp-elf-${ESP_IDF_FLAVOR}/bin:${PATH}
PATH:=	${LOCALBASE}/xtensa-esp-elf-${ESP_IDF_FLAVOR}/bin:${PATH}

# XXX disable DESTDIR during the build. in the build process, some external
# resources, e.g. newlib, install files under ${WRKDIR}/.build/_deps. DESTDIR
# changes the destination that cmake assmues, thus, the build fails because
# cmake cannot find it. enable DESTDIR later in do-install target.
DESTDIRNAME=	__DESTDIR_DISABLED__
CMAKE_INSTALL_PREFIX=	${STAGEDIR}${ESP_PREFIX}

# XXX disable security-check.awk. this causes too much disk space on GitHub
# Actions runner.
DISABLE_SECURITY_CHECK=	yes

.if ${PORTNAME} == esp-llvm-embedded-toolchain
ESP_STRIP_FILES=	\
	bin/clang-18 \
	bin/clang-format \
	bin/clang-tidy \
	bin/clangd \
	bin/dsymutil \
	bin/llc \
	bin/lld \
	bin/llvm-ar \
	bin/llvm-config \
	bin/llvm-cov \
	bin/llvm-cxxfilt \
	bin/llvm-dwarfdump \
	bin/llvm-nm \
	bin/llvm-objcopy \
	bin/llvm-objdump \
	bin/llvm-profdata \
	bin/llvm-readobj \
	bin/llvm-size \
	bin/llvm-symbolizer \
	bin/riscv32-esp-elf-clang-as \
	bin/riscv32-esp-elf-clang-ld \
	bin/riscv32-esp-elf-clang-objcopy \
	bin/riscv32-esp-elf-clang-objdump \
	bin/xtensa-esp32-elf-clang-as \
	bin/xtensa-esp32-elf-clang-ld \
	bin/xtensa-esp32-elf-clang-objcopy \
	bin/xtensa-esp32-elf-clang-objdump \
	bin/xtensa-esp32s2-elf-clang-as \
	bin/xtensa-esp32s2-elf-clang-ld \
	bin/xtensa-esp32s2-elf-clang-objcopy \
	bin/xtensa-esp32s2-elf-clang-objdump \
	bin/xtensa-esp32s3-elf-clang-as \
	bin/xtensa-esp32s3-elf-clang-ld \
	bin/xtensa-esp32s3-elf-clang-objcopy \
	bin/xtensa-esp32s3-elf-clang-objdump \
	lib/libLTO.so.18.1
.elif ${PORTNAME} == esp-llvm-embedded-toolchain-libs-clang
ESP_STRIP_FILES=	lib/*.so \
					lib/*.so.*
.endif

SHEBANG_FILES=	\
	${WRKDIR}/llvm-project-${ESP_REF_LLVM_PROJECT}/clang/tools/clang-format/git-clang-format \
	${WRKDIR}/llvm-project-${ESP_REF_LLVM_PROJECT}/clang-tools-extra/clang-tidy/tool/run-clang-tidy.py \
	${WRKDIR}/llvm-project-${ESP_REF_LLVM_PROJECT}/clang/tools/clang-format/clang-format-diff.py \
	${WRKDIR}/llvm-project-${ESP_REF_LLVM_PROJECT}/clang-tools-extra/clang-tidy/tool/clang-tidy-diff.py

# build clang only to fill ccache cache. see
# .github/workflows/release-binaries.yml in espressif/llvm-project.
#
# experimental. not used in workflows
.if defined(ESP_BUILD_CLANG_ONLY)
INSTALL_TARGET=	clang
CMAKE_SOURCE_PATH=	${WRKDIR}/llvm-project-${ESP_REF_LLVM_PROJECT}
CMAKE_ARGS=	\
	-C ${WRKDIR}/llvm-project-${ESP_REF_LLVM_PROJECT}/clang/cmake/caches/Release.cmake \
	-S ${WRKDIR}/llvm-project-${ESP_REF_LLVM_PROJECT}/llvm \
	-DCMAKE_POSITION_INDEPENDENT_CODE=ON \
	-B ${CONFIGURE_WRKSRC}
.endif

.include <bsd.port.pre.mk>

# work around CMAKE/CCACHE flaw (cmake stomps over ccache)
# obtained from graphics/darktable.
.if "${WITH_CCACHE_BUILD}" == "yes" && !defined(NO_CCACHE)
CMAKE_ARGS+=	-DCMAKE_C_COMPILER_LAUNCHER=${CCACHE_BIN} \
		-DCMAKE_CXX_COMPILER_LAUNCHER=${CCACHE_BIN}
.endif

pre-configure:
	@${REINPLACE_CMD} -e 's|%%ESP_TMPDIR%%|${ESP_TMPDIR}|g' \
		${WRKSRC}/cmake/esp-gnu-components.cmake
	@${REINPLACE_CMD} -e 's|%%ESP_LLVM_VERSION%%|${ESP_LLVM_VERSION}|g' \
		-e 's|%%ESP_SNAPDATE%%|${ESP_SNAPDATE}|g' \
		-e 's|%%ESP_REF_LLVM_PROJECT%%|${ESP_REF_LLVM_PROJECT}|g' \
		-e 's|%%ESP_REF_PICOLIBC%%|${ESP_REF_PICOLIBC}|g' \
		-e 's|%%ESP_REF_NEWLIB_ESP32%%|${ESP_REF_NEWLIB_ESP32}|g' \
		${WRKSRC}/cmake/generate_version_txt.cmake

	${MKDIR} -p ${WRKDIR}/.build/_deps

# extract dependencies in places cmake expects
.for _org project tag group in ${ESP_GH_TUPLE:C/:/ /g}
	${LN} -s ${WRKDIR}/${project}-${tag} ${WRKDIR}/.build/_deps/${group}-src
.endfor
	${LN} -s ${LOCALBASE}/riscv32-esp-elf-${ESP_IDF_FLAVOR} ${WRKDIR}/.build/_deps/esp_riscv32_gnu_toolchain-src
	${LN} -s ${LOCALBASE}/xtensa-esp-elf-${ESP_IDF_FLAVOR} ${WRKDIR}/.build/_deps/esp_xtensa_gnu_toolchain-src

pre-build:
	${MKDIR} ${ESP_TMPDIR}

# TODO should be removed
do-install:
.if ${INSTALL_TARGET} != clang
	(cd ${INSTALL_WRKSRC} && ${SETENVI} ${WRK_ENV} ${MAKE_ENV} ${FAKEROOT} \
		${MAKE_CMD} ${MAKE_FLAGS} ${MAKEFILE} ${MAKE_ARGS} ${INSTALL_TARGET})
.endif

post-install:
.for F in ${ESP_STRIP_FILES}
	@${STRIP_CMD} ${STAGEDIR}${ESP_PREFIX}/${F}
	@${RM} ${STAGEDIR}${ESP_PREFIX}/bin/*.cfg
.endfor

.include <bsd.port.post.mk>
