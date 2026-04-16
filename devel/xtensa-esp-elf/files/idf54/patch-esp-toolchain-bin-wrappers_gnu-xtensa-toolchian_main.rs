--- esp-toolchain-bin-wrappers/gnu-xtensa-toolchian/main.rs.orig	2024-05-27 15:04:40 UTC
+++ esp-toolchain-bin-wrappers/gnu-xtensa-toolchian/main.rs
@@ -151,7 +151,7 @@ fn main() {
     let dynconfig_path = bin_dir
         .parent()
         .expect("Toolchain must be in some directory")
-        .join("lib")
+        .join("%%PREFIX%%/lib")
         .as_path()
         .join(dynconfig_filename.clone());
 
