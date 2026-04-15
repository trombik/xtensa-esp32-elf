--- scripts/build/binutils/binutils.sh.orig	2025-12-15 12:50:27 UTC
+++ scripts/build/binutils/binutils.sh
@@ -116,6 +116,9 @@ map_triplet_to_rust() {
         x86_64*-mingw32)
             echo "x86_64-pc-windows-gnu"
             ;;
+        x86_64-*-freebsd*)
+            echo "x86_64-unknown-freebsd"
+            ;;
         *)
             echo "Unsupported"
             CT_DoLog ERROR ">> map_triplet_to_rust: unknown mapping for: $gcc_triplet"
@@ -124,29 +127,14 @@ do_binutils_install_bin_wrappers () {
 }
 
 do_binutils_install_bin_wrappers () {
-    CT_DoLog EXTRA "Installing rust for binutils wrappers"
-    export RUSTUP_HOME=${CT_BUILD_DIR}/rust/rustup
-    export CARGO_HOME=${CT_BUILD_DIR}/rust/cargo
-    export CARGO_NET_GIT_FETCH_WITH_CLI=true
     export CARGO_TARGET_DIR=${CT_BUILD_DIR}/esp_bin_wrapper
-    RUST_VERSION=1.86.0
 
-    CT_mkdir_pushd "${CT_BUILD_DIR}/rust"
-    CT_DoExecLog ALL curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup.sh
-    CT_DoExecLog ALL chmod +x rustup.sh
-    setarch ${CT_BUILD%%-*} ./rustup.sh -y \
-        --no-modify-path \
-        --default-toolchain "$RUST_VERSION" 2>&1
-    CT_DoExecLog ALL ${CT_BUILD_DIR}/rust/cargo/bin/rustup target add $(map_triplet_to_rust ${CT_HOST})
-    CT_DoExecLog ALL rm rustup.sh
-    CT_Popd
-
     CT_DoLog EXTRA "Building binutils wrappers"
 
     rust_target=$(map_triplet_to_rust ${CT_HOST})
 
     CT_Pushd "${CT_BINUTILS_ESP32P4_BIN_WRAPPERS_LOCATION}"
-    CT_DoExecLog ALL CT_DoExecLog ALL ${CT_BUILD_DIR}/rust/cargo/bin/cargo build --release --target=${rust_target} --config target.${rust_target}.linker=\"${CT_HOST}-gcc\"
+    CT_DoExecLog ALL CT_DoExecLog ALL ${CARGO} build --release --target=${rust_target} --config target.${rust_target}.linker=\"${CT_HOST}-gcc\"
     CT_Popd
 
     rust_target=$(map_triplet_to_rust ${CT_HOST})
