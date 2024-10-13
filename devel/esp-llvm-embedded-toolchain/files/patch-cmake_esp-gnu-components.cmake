--- cmake/esp-gnu-components.cmake.orig	2024-10-12 05:07:48 UTC
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
