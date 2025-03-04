PORTNAME?=	rust-esp
DISTVERSION=	${ESPRUST_VERSION}
#PORTREVISION=	1
CATEGORIES=	lang
MASTER_SITES=

MAINTAINER=	y@trombik.org
COMMENT?=	Rust for the xtensa architecture by espressif
WWW=	https://github.com/esp-rs/rust

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/LICENSE-MIT

DISTVERSIONPREFIX=	esp-

# the build process uses features only available in nightly.
BUILD_DEPENDS=	rust-nightly>0:lang/rust-nightly \
	${LOCALBASE}/lib/libonig.so:devel/oniguruma
LIB_DEPENDS?=	\
	libssh2.so:security/libssh2 \
	libgit2.so:devel/libgit2
RUN_DEPENDS=	${LOCALBASE}/esp-llvm-embedded-toolchain/bin/clang:devel/esp-llvm-embedded-toolchain \
	${LOCALBASE}/riscv32-esp-elf-${ESP_IDF_FLAVOR}/bin/riscv32-esp-elf-gcc:devel/riscv32-esp-elf@${ESP_IDF_FLAVOR} \
	${LOCALBASE}/xtensa-esp-elf-${ESP_IDF_FLAVOR}/bin/xtensa-esp-elf-gcc:devel/xtensa-esp-elf@${ESP_IDF_FLAVOR}


USES=	python:3.0+ cargo ninja
.if ${PORTNAME} == "rust-esp"
RUN_DEPENDS+=	${LOCALBASE}/rust-esp-src/lib/rustlib/src/rust/library/core/src/lib.rs:lang/rust-esp-src
USES+=	ssl
.elif ${PORTNAME} == "rust-esp-src"
.endif
MASTERDIR?=	${.CURDIR}

USE_GITHUB=	yes
# see the latest commit ref in ESPRUST_VERSION branch in esp-rs/rust
GH_TUPLE=	esp-rs:rust:fc08bef
WITHOUT_LTO=	yes

# to update GH_TUPLE for submodules, run:
# rm distinfo
# echo > Makfile.submodules
# make fetch makesum
# make patch makesubmodule
# make makesum
# sh files/update_crates.sh
#
# XXX the above steps might not always work.
MAKEFILE_SUBMODULES=	Makefile.submodule
.include "${MASTERDIR}/${MAKEFILE_SUBMODULES}"

ONLY_FOR_ARCHS=	amd64
ESPRUST_ARCH=	x86_64
ESPRUST_TUPLE=	${ESPRUST_ARCH}-unknown-freebsd
ESPRUST_COMPONENTS_VERSION=	nightly
ESP_IDF_FLAVOR=	idf53

# the component rustup needs
ESPRUST_RUSTUP_COMPONENT=	rust-${ESPRUST_COMPONENTS_VERSION}-${ESPRUST_TUPLE}

# the file name rustup expects
ESPRUST_RUSTUP_COMPONENT_NAME?=	rust-${ESPRUST_VERSION}-${ESPRUST_TUPLE}

# use this to find out the path to the artifact and the name for release by:
# make -V ESPRUST_RUSTUP_COMPONENT_FULLPATH
# and
# make -V ESPRUST_RUSTUP_COMPONENT_NAME
ESPRUST_RUSTUP_COMPONENT_FULLPATH?=	${ESPRUST_DIST_DIR}/${ESPRUST_RUSTUP_COMPONENT_NAME}.tar.xz

# components to extract and install
ESPRUST_COMPONENTS?=	${ESPRUST_RUSTUP_COMPONENT}

# where tarballs are kept
ESPRUST_DIST_DIR=	${WRKSRC}/build/dist

# where to extract components
ESPRUST_EXTRACT_DIR=	${WRKDIR}/_extractdist

# where to install components without ${PREFIX}
ESPRUST_ROOT_DIR=	${PORTNAME}

# to update the list of crates, run:
# sh files/update_crates.sh
MAKEFILE_CRATES=	Makefile.rust.crates
.include "${MASTERDIR}/${MAKEFILE_CRATES}"

# XXX remove duplicates
CARGO_CRATES!=	(${ECHO} ${CARGO_CRATES} | /usr/bin/tr ' ' '\n' | /usr/bin/sort -u) || ${ECHO} ""

# XXX disable CARGO_BUILDDEP because cargo.mk add lang/rust, not
# lang/rust-nightly, to BUILD_DEPENDS,
CARGO_BUILDDEP=	no
CARGO_CARGOTOML?=	${WRKSRC}/Cargo.toml
CARGO_CARGOLOCK?=	${WRKSRC}/Cargo.lock

# see src/version
ESPRUST_UPSTREAM_VERSION=	1.85.0

# see compiler_version in src/stage0
ESPRUST_COMPILER_VERSION=	1.84.0

# see compiler_date in src/stage0
ESPRUST_RELEASE_DATE=	2025-01-09

# see change_id of the last entry of CONFIG_CHANGE_HISTORY in src/bootstrap/src/utils/change_tracker.rs
ESPRUST_CHANGE_ID=	134650

# see https://github.com/esp-rs/rust-build/releases
# x.y.z.${ESPRUST_PATCH_LEVEL}
ESPRUST_PATCH_LEVEL=	0
ESPRUST_VERSION=	${ESPRUST_UPSTREAM_VERSION}.${ESPRUST_PATCH_LEVEL}

ESPRUST_BUILD_CACHE_DIR=	${WRKSRC}/build/cache/${ESPRUST_RELEASE_DATE}
ESPRUST_MASTER_SITE=	https://static.rust-lang.org
ESPRUST_STAGE_PACKAGES=	cargo \
						rust-std \
						rustc
.for F in ${ESPRUST_STAGE_PACKAGES}
ESPRUST_STAGE_FILES+=	${F}-${ESPRUST_COMPILER_VERSION}-${ESPRUST_TUPLE}.tar.xz
MASTER_SITES+=	${ESPRUST_MASTER_SITE}/dist/${ESPRUST_RELEASE_DATE}/:src_${F:S/-/_/}
DISTFILES+=	${F}-${ESPRUST_COMPILER_VERSION}-${ESPRUST_TUPLE}.tar.xz:src_${F:S/-/_/}
.endfor

# see support/rust-build/x86_64-unknown-linux-gnu/build.sh in
# esp-rs/rust-build at:
# https://github.com/esp-rs/rust-build/blob/main/support/rust-build/x86_64-unknown-linux-gnu/build.sh
ESPRUST_CONFIGURE_SCRIPT=	${WRKSRC}/src/bootstrap/configure.py

# the original configure arguments
ESPRUST_CONFIGURE_ARGS?=	--experimental-targets=Xtensa --release-channel=nightly --release-description="${ESPRUST_VERSION}" --enable-extended --enable-cargo-native-static --tools=clippy,cargo,rustfmt,rust-analyzer-proc-macro-srv --dist-compression-formats='xz' --enable-lld
# our own configure arguments
ESPRUST_CONFIGURE_ARGS+=	--set=build.verbose=2 \
	--set=build.python=${PYTHON_CMD} \
	--set=install.prefix=${PREFIX}/${ESPRUST_ROOT_DIR} \
	--set=install.sysconfdir=${PREFIX}/${ESPRUST_ROOT_DIR}/etc \
	--set=llvm.ninja=true \
	--set=dist.src-tarball=false \
	--set=rust.deny-warnings=false

# XXX you cannot use CCACHE_ENABLED here.
# see https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=277204
.if "${WITH_CCACHE_BUILD:tl}" == "yes" && !defined(NO_CCACHE)
ESPRUST_USING_SCCACHE=	yes
.endif
.if defined(POUDRIERE_BUILD_TYPE)
ESPRUST_USING_POUDRIERE=	yes
.else
ESPRUST_USING_POUDRIERE=	no
.endif

.if defined(ESPRUST_USING_SCCACHE) # ESPRUST_USING_SCCACHE
BUILD_DEPENDS+=	ccache:devel/ccache
.if ${ESPRUST_USING_POUDRIERE} == "no" # ESPRUST_USING_POUDRIERE == no
BUILD_DEPENDS+=	sccache:ports-mgmt/sccache-overlay
.endif # ESPRUST_USING_POUDRIERE == no
ESPRUST_CONFIGURE_ARGS+=	--set=llvm.ccache=sccache
BINARY_ALIAS+=	sccache=${SCCACHE_BIN}
.endif # ESPRUST_USING_SCCACHE

ESPRUST_BUILD_CMD=	${PYTHON_CMD} x.py
ESPRUST_BUILD_ARGS?=	dist --stage 2 --jobs=${MAKE_JOBS_NUMBER}

makesubmodule:
	${SH} ${FILESDIR}/gh_tuple.sh ${DISTVERSIONFULL} > ${MAKEFILE_SUBMODULES}

post-extract:
	${MKDIR} ${ESPRUST_BUILD_CACHE_DIR}
.for F in ${ESPRUST_STAGE_FILES}
	echo ${F}
	(cd ${ESPRUST_BUILD_CACHE_DIR} && ${LN} -s ${DISTDIR}/${F} .)
.endfor


do-configure:
	(cd ${WRKSRC} && ${SETENVI} ${CONFIGURE_ENV} ${PYTHON_CMD} ${ESPRUST_CONFIGURE_SCRIPT} ${ESPRUST_CONFIGURE_ARGS})

	# add change-id to config.toml to avoid a warning
	${ECHO} "change-id = ${ESPRUST_CHANGE_ID}" > ${WRKSRC}/config.toml.new
	${CAT} ${WRKSRC}/config.toml >> ${WRKSRC}/config.toml.new
	${MV} ${WRKSRC}/config.toml.new ${WRKSRC}/config.toml

	${ECHO_MSG} "===> ${WRKSRC}/config.toml"
	@${CAT} ${WRKSRC}/config.toml

do-build:
	(cd ${WRKSRC} && ${SETENVI} ${WRK_ENV} ${MAKE_ENV} ${CARGO_ENV} ${ESPRUST_BUILD_CMD} ${ESPRUST_BUILD_ARGS})

post-build:
.if defined(ESPRUST_USING_SCCACHE)
	${BSDMAKE} sccache-stats
.endif

do-install:
	# XXX remove unnecessary directories to save disk space.
	# on GitHub runners, the workflow to build stops due to lack of enough
	# space on the disk.
	${RM} -r ${WRKSRC}/build/tmp ${WRKSRC}/build/tmp ${WRKSRC}/build/${ESPRUST_TUPLE}

	${RM} -r ${ESPRUST_EXTRACT_DIR}
.for C in ${ESPRUST_COMPONENTS}
	${MKDIR} ${ESPRUST_EXTRACT_DIR}
	${TAR} xf  ${ESPRUST_DIST_DIR}/${C}.tar.xz -C ${ESPRUST_EXTRACT_DIR}
	cd ${ESPRUST_EXTRACT_DIR}/${C} && \
		${SH} install.sh \
		--docdir="${STAGEDIR}${DOCSDIR}" \
		--mandir="${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/share/man" \
		--prefix="${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}"
	${RM} -r ${ESPRUST_EXTRACT_DIR}
.endfor

# We autogenerate the plist file.  We do that, instead of the
# regular pkg-plist, because several libraries have a computed
# filename based on the absolute path of the source files.  As it
# is user-specific, we cannot know their filename in advance.
	@${RM}	${STAGEDIR}${DOCSDIR}/*.old \
		${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/lib/rustlib/components \
		${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/lib/rustlib/install.log \
		${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/lib/rustlib/manifest-* \
		${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/lib/rustlib/rust-installer-version \
		${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/lib/rustlib/uninstall.sh
.if ${PORTNAME} == "rust-esp"
	@${FIND} ${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/bin ${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/lib \
		${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/libexec -exec ${FILE} -i {} + | \
		${AWK} -F: '/executable|sharedlib/ { print $$1 }' | ${XARGS} ${STRIP_CMD}

	${MKDIR} ${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/lib/rustlib/src
	(cd ${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/lib/rustlib/src && ${LN} -s ../../../../rust-esp-src/lib/rustlib/src/rust rust)
.endif
	@${FIND} ${STAGEDIR}${PREFIX} -not -type d | \
		${SED} -E -e 's,^${STAGEDIR}${PREFIX}/,,' \
			-e 's,(share/man/man[1-9]/.*\.[0-9]),\1.gz,' >> ${TMPPLIST}
.if ${PORTNAME} == "rust-esp"
	@${FIND} ${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/share/man -type f -exec ${GZIP_CMD} {} +

# Ignore any left behind empty directories in case some docs fail
# to build (failures are ignored due to deny-warnings=false).
	@${FIND} ${STAGEDIR}${DOCSDIR}/html -empty -type d | \
		${SED} 's,^${STAGEDIR},@comment @dir ,' >> ${TMPPLIST}
.endif

.if ${PORTNAME} == "rust-esp-src"
# Silence stage-qa warnings by sanitizing permissions on sources
	@${FIND} ${STAGEDIR}${PREFIX}/${ESPRUST_ROOT_DIR}/lib/rustlib/src -type f -exec ${CHMOD} \
		${SHAREMODE} {} +
.endif

.include <bsd.port.mk>
