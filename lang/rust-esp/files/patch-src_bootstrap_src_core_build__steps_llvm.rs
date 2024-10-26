--- src/bootstrap/src/core/build_steps/llvm.rs.orig	2024-10-26 00:36:52 UTC
+++ src/bootstrap/src/core/build_steps/llvm.rs
@@ -727,6 +727,7 @@ fn configure_cmake(
             .define("CMAKE_ASM_COMPILER", sanitize_cc(&cc));
     }
 
+    cfg.build_arg("--verbose").build_arg("--verbose");
     cfg.build_arg("-j").build_arg(builder.jobs().to_string());
     let mut cflags: OsString = builder
         .cflags(target, GitRepo::Llvm, CLang::C)
