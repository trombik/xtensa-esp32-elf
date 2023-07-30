--- build_esp_gdb.sh.orig	2022-11-01 16:32:48 UTC
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
@@ -87,10 +89,9 @@ --target=${ESP_CHIP_ARCHITECTURE}-esp-elf \
 CONFIG_OPTS=" \
 --host=$TARGET_HOST \
 --target=${ESP_CHIP_ARCHITECTURE}-esp-elf \
---build=`gcc -dumpmachine` \
+--build=`${CC} -dumpmachine` \
 --disable-werror \
 --with-expat \
---with-libexpat-prefix=/opt/expat-$TARGET_HOST \
 --disable-threads \
 --disable-sim \
 --disable-nls \
@@ -98,16 +99,12 @@ --disable-source-highlight \
 --disable-ld \
 --disable-gas \
 --disable-source-highlight \
---prefix=/ \
---with-gmp=/opt/gmp-$TARGET_HOST \
---with-libgmp-prefix=/opt/gmp-$TARGET_HOST \
---with-mpc=/opt/mpc-$TARGET_HOST \
+--prefix=%%PREFIX%% \
+--with-gmp \
+--with-mpc \
 --without-mpfr \
 ${PYTHON_CONFIG_OPTS} \
 ${WITH_XTENSACONFIG_OPTS} \
---with-libexpat-type=static \
---with-liblzma-type=static \
---with-libgmp-type=static \
 --with-static-standard-libraries \
 --with-pkgversion="esp-gdb" \
 --with-curses \
@@ -135,10 +132,6 @@ make install DESTDIR=$GDB_DIST
 make
 make install DESTDIR=$GDB_DIST
 
-#strip binaries. Save user's disc space
-${TARGET_HOST}-strip $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb${EXE}
-${TARGET_HOST}-strip $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gprof${EXE}
-
 GDB_PROGRAM_SUFFIX=
 if [ $BUILD_PYTHON_VERSION == "without_python" ]; then
   GDB_PROGRAM_SUFFIX="no-python"
@@ -147,7 +140,7 @@ fi
 fi
 
 # rename gdb to have python version in filename
-mv $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb${EXE} $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb-${GDB_PROGRAM_SUFFIX}${EXE}
+mv ${GDB_DIST}${PREFIX}/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb${EXE} ${GDB_DIST}${PREFIX}/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb-${GDB_PROGRAM_SUFFIX}${EXE}
 
 # rename wrapper to original gdb name
-mv $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb-wrapper${EXE} $GDB_DIST/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb${EXE} 2> /dev/null || true
+mv ${GDB_DIST}${PREFIX}/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb-wrapper${EXE} ${GDB_DIST}${PREFIX}/bin/${ESP_CHIP_ARCHITECTURE}-esp-elf-gdb${EXE} 2> /dev/null || true
