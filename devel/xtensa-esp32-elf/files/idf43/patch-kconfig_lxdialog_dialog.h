--- kconfig/lxdialog/dialog.h.orig	2022-07-12 04:46:10 UTC
+++ kconfig/lxdialog/dialog.h
@@ -26,11 +26,7 @@
 #include <string.h>
 #include <stdbool.h>
 
-#ifndef KBUILD_NO_NLS
-# include <libintl.h>
-#else
 # define gettext(Msgid) ((const char *) (Msgid))
-#endif
 
 #ifdef __sun__
 #define CURS_MACROS
