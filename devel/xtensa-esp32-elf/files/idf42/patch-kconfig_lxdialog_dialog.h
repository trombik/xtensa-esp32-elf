--- kconfig/lxdialog/dialog.h.orig	2019-08-12 08:34:34 UTC
+++ kconfig/lxdialog/dialog.h
@@ -26,11 +26,7 @@
 #include <string.h>
 #include <stdbool.h>
 
-#ifndef KBUILD_NO_NLS
-# include <libintl.h>
-#else
-# define gettext(Msgid) ((const char *) (Msgid))
-#endif
+#define gettext(Msgid) ((const char *) (Msgid))
 
 #ifdef __sun__
 #define CURS_MACROS
