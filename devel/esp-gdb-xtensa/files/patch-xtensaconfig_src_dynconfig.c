--- xtensaconfig/src/dynconfig.c.orig	2023-07-30 03:21:47 UTC
+++ xtensaconfig/src/dynconfig.c
@@ -19,6 +19,7 @@
 #elif _WIN32
 #include <windows.h>
 #endif
+#include <sys/syslimits.h>
 
 #include "xtensaconfig/dynconfig.h"
 
