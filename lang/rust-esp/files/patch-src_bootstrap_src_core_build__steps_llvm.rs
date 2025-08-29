--- src/bootstrap/src/core/build_steps/llvm.rs.orig	2025-08-20 10:40:37 UTC
+++ src/bootstrap/src/core/build_steps/llvm.rs
@@ -746,6 +746,7 @@ fn configure_cmake(
         .define("CMAKE_CXX_COMPILER", sanitize_cc(&cxx))
         .define("CMAKE_ASM_COMPILER", sanitize_cc(&cc));
 
+    cfg.build_arg("--verbose").build_arg("--verbose");
     cfg.build_arg("-j").build_arg(builder.jobs().to_string());
     // FIXME(madsmtm): Allow `cmake-rs` to select flags by itself by passing
     // our flags via `.cflag`/`.cxxflag` instead.
