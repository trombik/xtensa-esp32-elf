--- esp-toolchain-bin-wrappers/gnu-xtensa-toolchian/main.rs.orig	2025-09-28 13:42:05 UTC
+++ esp-toolchain-bin-wrappers/gnu-xtensa-toolchian/main.rs
@@ -138,7 +138,7 @@ fn main() {
     let dynconfig_path = bin_dir
         .parent()
         .expect("Toolchain must be in some directory")
-        .join("lib")
+        .join("%%PREFIX%%/lib")
         .join(dynconfig_filename.clone());
 
     assert!(
