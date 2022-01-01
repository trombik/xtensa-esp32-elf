--- kconfig/lkc.h.orig	2019-08-12 08:34:34 UTC
+++ kconfig/lkc.h
@@ -8,14 +8,10 @@
 
 #include "expr.h"
 
-#ifndef KBUILD_NO_NLS
-# include <libintl.h>
-#else
 static inline const char *gettext(const char *txt) { return txt; }
 static inline void textdomain(const char *domainname) {}
 static inline void bindtextdomain(const char *name, const char *dir) {}
 static inline char *bind_textdomain_codeset(const char *dn, char *c) { return c; }
-#endif
 
 #ifdef __cplusplus
 extern "C" {
