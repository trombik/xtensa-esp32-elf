--- src/bootstrap/src/core/build_steps/dist.rs.orig	2025-08-30 05:42:33 UTC
+++ src/bootstrap/src/core/build_steps/dist.rs
@@ -518,12 +518,6 @@ impl Step for Rustc {
             // Debugger scripts
             builder.ensure(DebuggerScripts { sysroot: image.to_owned(), host });
 
-            // HTML copyright files
-            let file_list = builder.ensure(super::run::GenerateCopyright);
-            for file in file_list {
-                builder.install(&file, &image.join("share/doc/rust"), FileType::Regular);
-            }
-
             // README
             builder.install(
                 &builder.src.join("README.md"),
