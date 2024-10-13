--- cmake/generate_version_txt.cmake.orig	2024-10-14 11:36:46 UTC
+++ cmake/generate_version_txt.cmake
@@ -10,7 +10,7 @@ if(NOT ${LLVMEmbeddedToolchainForArm_COMMIT} MATCHES "
 
 if(NOT ${LLVMEmbeddedToolchainForArm_COMMIT} MATCHES "^[a-f0-9]+$")
     execute_process(
-        COMMAND git -C ${LLVMEmbeddedToolchainForArm_SOURCE_DIR} rev-parse HEAD
+        COMMAND echo %%ESP_LLVM_VERSION%%_%%ESP_SNAPDATE%%
         OUTPUT_VARIABLE LLVMEmbeddedToolchainForArm_COMMIT
         OUTPUT_STRIP_TRAILING_WHITESPACE
         COMMAND_ERROR_IS_FATAL ANY
@@ -18,14 +18,14 @@ execute_process(
 endif()
 
 execute_process(
-    COMMAND git -C ${llvmproject_SOURCE_DIR} rev-parse HEAD
+    COMMAND echo %%ESP_REF_LLVM_PROJECT%%
     OUTPUT_VARIABLE llvmproject_COMMIT
     OUTPUT_STRIP_TRAILING_WHITESPACE
     COMMAND_ERROR_IS_FATAL ANY
 )
 if(NOT "${picolibc_SOURCE_DIR}" STREQUAL "")
     execute_process(
-        COMMAND git -C ${picolibc_SOURCE_DIR} rev-parse HEAD
+        COMMAND echo %%ESP_REF_PICOLIBC%%
         OUTPUT_VARIABLE picolibc_COMMIT
         OUTPUT_STRIP_TRAILING_WHITESPACE
         COMMAND_ERROR_IS_FATAL ANY
@@ -33,7 +33,7 @@ if(NOT "${newlib_SOURCE_DIR}" STREQUAL "")
 endif()
 if(NOT "${newlib_SOURCE_DIR}" STREQUAL "")
     execute_process(
-        COMMAND git -C ${newlib_SOURCE_DIR} rev-parse HEAD
+        COMMAND echo %%ESP_REF_NEWLIB_ESP32%%
         OUTPUT_VARIABLE newlib_COMMIT
         OUTPUT_STRIP_TRAILING_WHITESPACE
         COMMAND_ERROR_IS_FATAL ANY
