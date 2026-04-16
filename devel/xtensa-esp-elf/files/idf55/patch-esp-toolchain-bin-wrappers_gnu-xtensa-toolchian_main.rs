--- esp-toolchain-bin-wrappers/gnu-xtensa-toolchian/main.rs.orig	2026-01-26 07:02:01 UTC
+++ esp-toolchain-bin-wrappers/gnu-xtensa-toolchian/main.rs
@@ -138,7 +138,7 @@ fn main() {
     let dynconfig_path = bin_dir
         .parent()
         .expect("Toolchain must be in some directory")
-        .join("lib")
+        .join("%%PREFIX%%/lib")
         .join(dynconfig_filename.clone());
 
     assert!(
