--- gas/config/esp32ulp-parse.y.orig	2019-12-04 05:22:11 UTC
+++ gas/config/esp32ulp-parse.y
@@ -760,9 +760,6 @@ any_gotrel:
 	GOT
 	{ $$ = BFD_RELOC_ESP32ULP_GOT; }
 	| GOT17M4
-	{ $$ = BFD_RELOC_ESP32ULP_GOT17M4; }
-	| FUNCDESC_GOT17M4
-	{ $$ = BFD_RELOC_ESP32ULP_FUNCDESC_GOT17M4; }
 	;
 
 got:	symbol AT any_gotrel
