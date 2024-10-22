--- cmake/esp-gnu-components.cmake.orig	2024-08-29 07:46:34 UTC
+++ cmake/esp-gnu-components.cmake
@@ -228,7 +228,7 @@ function(
         string(REPLACE "-" ";" var_comps ${target_triple})
         list(GET var_comps 1 cpu)
         get_filename_component(binutils_src_dir ${binutils_SOURCE_DIR} NAME)
-        set(binutils_src_dir /tmp/${binutils_src_dir}_${target_triple})
+        set(binutils_src_dir %%ESP_TMPDIR%%/${binutils_src_dir}_${target_triple})
         message(STATUS "Make source dir copy for ${cpu}. ${binutils_SOURCE_DIR} -> ${binutils_src_dir}")
         file(COPY ${binutils_SOURCE_DIR}/ DESTINATION ${binutils_src_dir})
         message(STATUS "Apply Xtensa overlay for ${cpu}. ${xtensa_overlays_SOURCE_DIR}/xtensa_${cpu}/binutils -> ${binutils_src_dir}")
@@ -248,7 +248,7 @@ function(
             ${binutils_src_dir}/configure --host=${HOST_TRIPLE} --target=${target_triple} --prefix=<INSTALL_DIR>
                 --program-prefix=${target_triple}-clang-
                 ${config_opts}
-        BUILD_COMMAND make -j${MAKE_JOBS_NUM}
+        BUILD_COMMAND make -j${MAKE_JOBS_NUM} V=1
         INSTALL_COMMAND make install-strip
         USES_TERMINAL_CONFIGURE TRUE
         USES_TERMINAL_BUILD TRUE
