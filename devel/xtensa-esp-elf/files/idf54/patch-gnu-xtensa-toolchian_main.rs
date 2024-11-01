--- esp-toolchain-bin-wrappers/gnu-xtensa-toolchian/main.rs.orig	2024-09-04 20:44:29.300679000 +0700
+++ esp-toolchain-bin-wrappers/gnu-xtensa-toolchian/main.rs	2024-09-04 20:44:50.234827000 +0700
@@ -151,7 +151,7 @@
     let dynconfig_path = bin_dir
         .parent()
         .expect("Toolchain must be in some directory")
-        .join("lib")
+        .join("%%PREFIX%%/lib")
         .as_path()
         .join(dynconfig_filename.clone());
 
