--- scripts/build/companion_libs/901-xtensa_esp_bin_wrappers.sh.orig	2025-09-28 17:31:36 UTC
+++ scripts/build/companion_libs/901-xtensa_esp_bin_wrappers.sh
@@ -42,6 +41,9 @@ map_triplet_to_rust() {
         x86_64*-mingw32)
             echo "x86_64-pc-windows-gnu"
             ;;
+        x86_64-*-freebsd*)
+            echo "x86_64-unknown-freebsd"
+            ;;
         *)
             echo "Unsupported"
             CT_DoLog ERROR ">> map_triplet_to_rust: unknown mapping for: $gcc_triplet"
@@ -49,37 +51,15 @@ map_triplet_to_rust() {
     esac
 }
 
-do_xtensa_esp_bin_wrappers_get() {
-    CT_DoStep INFO "Installing rust for Espressif binary wrapper"
-
-    export RUSTUP_HOME=${CT_BUILD_DIR}/rust/rustup
-    export CARGO_HOME=${CT_BUILD_DIR}/rust/cargo
-    RUST_VERSION=1.86.0
-
-    CT_mkdir_pushd "${CT_BUILD_DIR}/rust"
-    CT_DoExecLog ALL curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup.sh
-    CT_DoExecLog ALL chmod +x rustup.sh
-    setarch ${CT_BUILD%%-*} ./rustup.sh -y \
-        --no-modify-path \
-        --default-toolchain "$RUST_VERSION" 2>&1
-    CT_DoExecLog ALL ${CT_BUILD_DIR}/rust/cargo/bin/rustup target add $(map_triplet_to_rust ${CT_HOST})
-    CT_DoExecLog ALL rm rustup.sh
-    CT_Popd
-    CT_EndStep
-}
-
 do_xtensa_esp_bin_wrappers_for_build () {
     CT_DoStep INFO "Building Espressif binary wrapper"
 
-    export RUSTUP_HOME=${CT_BUILD_DIR}/rust/rustup
-    export CARGO_HOME=${CT_BUILD_DIR}/rust/cargo
-    export CARGO_NET_GIT_FETCH_WITH_CLI=true
     export CARGO_TARGET_DIR=${CT_BUILD_DIR}/esp_bin_wrapper
 
     rust_target=$(map_triplet_to_rust ${CT_HOST})
 
     CT_Pushd "${CT_XTENSA_ESP_BIN_WRAPPERS_LOCATION}"
-    CT_DoExecLog ALL CT_DoExecLog ALL ${CT_BUILD_DIR}/rust/cargo/bin/cargo build --release --target=${rust_target} --config target.${rust_target}.linker=\"${CT_HOST}-gcc\"
+    CT_DoExecLog ALL CT_DoExecLog ALL ${CARGO} build --release --target=${rust_target} --config target.${rust_target}.linker=\"${CT_HOST}-gcc\"
     CT_Popd
 }
 
