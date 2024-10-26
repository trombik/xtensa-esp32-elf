From 7b6de2a991718ddb1c6b7ae9982453f1ada2e4fd Mon Sep 17 00:00:00 2001
From: Jesse Braham <jesse@beta7.io>
Date: Thu, 24 Oct 2024 09:28:46 +0200
Subject: [PATCH] If a port was specified via CLI or config, search *all*
 serial ports, not just the filtered list

--- espflash/src/cli/serial.rs.orig	2024-10-18 09:08:31 UTC
+++ espflash/src/cli/serial.rs
@@ -33,13 +33,14 @@ pub fn get_serial_port_info(
     // doesn't work (on Windows) with "dummy" device paths like `COM4`. That's
     // the reason we need to handle Windows/Posix differently.
 
-    let ports = detect_usb_serial_ports(matches.list_all_ports).unwrap_or_default();
-
     if let Some(serial) = &matches.port {
+        let ports = detect_usb_serial_ports(true).unwrap_or_default();
         find_serial_port(&ports, serial)
     } else if let Some(serial) = &config.connection.serial {
+        let ports = detect_usb_serial_ports(true).unwrap_or_default();
         find_serial_port(&ports, serial)
     } else {
+        let ports = detect_usb_serial_ports(matches.list_all_ports).unwrap_or_default();
         let (port, matches) = select_serial_port(ports, config, matches.confirm_port)?;
 
         match &port.port_type {
