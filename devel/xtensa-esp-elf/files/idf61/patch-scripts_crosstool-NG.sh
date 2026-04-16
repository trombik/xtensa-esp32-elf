--- scripts/crosstool-NG.sh.orig	2024-08-29 07:07:04 UTC
+++ scripts/crosstool-NG.sh
@@ -281,7 +281,7 @@ if [ "${CT_XTENSA_DYNCONFIG}" = "y" ]; then
 CT_DoArchMultilibList
 
 if [ "${CT_XTENSA_DYNCONFIG}" = "y" ]; then
-    export XTENSA_GNU_CONFIG="${CT_BUILDTOOLS_PREFIX_DIR}/xtensa-dynconfig/lib/"
+    export XTENSA_GNU_CONFIG="${CT_BUILDTOOLS_PREFIX_DIR}/xtensa-dynconfig%%PREFIX%%/lib/"
 fi
 
 CT_DoLog EXTRA "Preparing working directories"
