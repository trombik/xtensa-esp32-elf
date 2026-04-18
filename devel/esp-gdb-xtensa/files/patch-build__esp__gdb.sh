--- build_esp_gdb.sh.orig	2026-04-02 03:12:58 UTC
+++ build_esp_gdb.sh
@@ -1,5 +1,5 @@
 #!/bin/bash
-set -e
+set -e -x
 
 TARGET_HOST=$1
 ESP_CHIP_ARCHITECTURE=$2
@@ -23,6 +23,8 @@ elif  [[ ${TARGET_HOST} == *"apple-darwin"* ]] ; then
   PLATFORM="windows"
 elif  [[ ${TARGET_HOST} == *"apple-darwin"* ]] ; then
   PLATFORM="macos"
+elif  [[ ${TARGET_HOST} == *"freebsd"* ]] ; then
+  PLATFORM="freebsd"
 else # linux
   PLATFORM="linux"
 fi
@@ -58,8 +60,7 @@ if [ $ESP_CHIP_ARCHITECTURE == "xtensa" ]; then
 if [ $ESP_CHIP_ARCHITECTURE == "xtensa" ]; then
   # Build xtensa-config libs
   pushd xtensa-dynconfig
-  make clean
-  make CC=${TARGET_HOST}-gcc CONF_DIR="${GDB_REPO_ROOT}/xtensa-overlays"
+  make -j 8 CC=${TARGET_HOST}-${CC} CONF_DIR="${GDB_REPO_ROOT}/xtensa-overlays"
   make install DESTDIR="${GDB_DIST}"
   popd
 fi
@@ -108,10 +109,9 @@ --target=${ESP_CHIP_ARCHITECTURE}-esp-elf \
 CONFIG_OPTS=" \
 --host=$TARGET_HOST \
 --target=${ESP_CHIP_ARCHITECTURE}-esp-elf \
---build=`gcc -dumpmachine` \
+--build=`${CC} -dumpmachine` \
 --disable-werror \
---with-expat \
---with-libexpat-prefix=/opt/expat-$TARGET_HOST \
+--with-expat=%%PREFIX%% \
 --disable-threads \
 --disable-sim \
 --disable-nls \
@@ -119,17 +119,13 @@ --disable-source-highlight \
 --disable-ld \
 --disable-gas \
 --disable-source-highlight \
---prefix=/ \
---with-gmp=/opt/gmp-$TARGET_HOST \
---with-libgmp-prefix=/opt/gmp-$TARGET_HOST \
---with-mpc=/opt/mpc-$TARGET_HOST \
---with-mpfr=/opt/mpfr-$TARGET_HOST \
+--prefix=%%PREFIX%% \
+--with-gmp=%%PREFIX%% \
+--with-libgmp-prefix=%%PREFIX%% \
+--with-mpc=%%PREFIX%% \
+--with-mpfr=%%PREFIX%% \
 ${PYTHON_CONFIG_OPTS} \
---with-libexpat-type=static \
---with-liblzma-type=static \
---with-libgmp-type=static \
 ${LIBICONV_CONFIG_OPTS} \
---with-static-standard-libraries \
 --with-pkgversion="esp-gdb" \
 --with-curses \
 --enable-tui \
@@ -165,8 +161,8 @@ make install DESTDIR=$GDB_DIST
 make install DESTDIR=$GDB_DIST
 
 #strip binaries. Save user's disc space
-${TARGET_HOST}-strip $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb${EXE}
-${TARGET_HOST}-strip $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gprof${EXE}
+${TARGET_HOST}-strip $GDB_DIST%%PREFIX%%/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb${EXE}
+${TARGET_HOST}-strip $GDB_DIST%%PREFIX%%/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gprof${EXE}
 
 GDB_PROGRAM_SUFFIX=
 if [ $BUILD_PYTHON_VERSION == "without_python" ]; then
@@ -187,13 +183,13 @@ fi
 fi
 
 # rename gdb to have python version in filename
-mv $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb${EXE} $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb-${GDB_PROGRAM_SUFFIX}${EXE}
+mv ${GDB_DIST}${PREFIX}/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb${EXE} ${GDB_DIST}${PREFIX}/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb-${GDB_PROGRAM_SUFFIX}${EXE}
 
 # rename wrapper to original gdb name
 if [ $ESP_CHIP_ARCHITECTURE == "xtensa" ]; then
-  cp $GDB_DIST/bin/esp-elf-gdb-wrapper${EXE} $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp32-elf-gdb${EXE} 2> /dev/null || true
-  cp $GDB_DIST/bin/esp-elf-gdb-wrapper${EXE} $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp32s2-elf-gdb${EXE} 2> /dev/null || true
-  mv $GDB_DIST/bin/esp-elf-gdb-wrapper${EXE} $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp32s3-elf-gdb${EXE} 2> /dev/null || true
+  cp $GDB_DIST${PREFIX}/bin/esp-elf-gdb-wrapper${EXE} $GDB_DIST${PREFIX}/bin/${ESP_CHIP_ARCHITECTURE}-esp32-elf-gdb${EXE} 2> /dev/null || true
+  cp $GDB_DIST${PREFIX}/bin/esp-elf-gdb-wrapper${EXE} $GDB_DIST${PREFIX}/bin/${ESP_CHIP_ARCHITECTURE}-esp32s2-elf-gdb${EXE} 2> /dev/null || true
+  mv $GDB_DIST${PREFIX}/bin/esp-elf-gdb-wrapper${EXE} $GDB_DIST${PREFIX}/bin/${ESP_CHIP_ARCHITECTURE}-esp32s3-elf-gdb${EXE} 2> /dev/null || true
 else
-  mv $GDB_DIST/bin/esp-elf-gdb-wrapper${EXE} $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb${EXE} 2> /dev/null || true
+  mv $GDB_DIST${PREFIX}/bin/esp-elf-gdb-wrapper${EXE} $GDB_DIST${PREFIX}/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb${EXE} 2> /dev/null || true
 fi
