## `devel/xtensa-esp32-elf`

Updated port of `devel/xtensa-esp32-elf`. This port will not be merged to the
official ports tree. See bug [251659](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=251659).

For `openocd` debugger, use
[trombik/freebsd-ports-openocd-esp32](https://github.com/trombik/freebsd-ports-openocd-esp32).

## Status

* `portlint(1)` is NOT happy (see #6)
* built successfully in `poudriere(8)`
* successfully built an example in the master branch of `esp-idf`
* successfully built [`esp32-cam`](https://github.com/bkeevil/esp32-cam)
* successfully built a Blink example with [arduino-esp32](https://github.com/espressif/arduino-esp32)
  version 1.0.6 (aka version 3.10006.210326 in `platformio`)
* the port is now `FLAVOR`-ed
* the port is now the master port of `xtensa-esp32s2-elf`, which should work with
  `esp-idf`. Not tested with `platformio` (needs ULP co-processor toolchain).
* the repository includes `devel/binutils-esp32ulp` and `devel/binutils-esp32s2ulp` (not tested
  yet)

## Usage

Copy the repository to your ports tree (use [`ports-mgmt/portshaker`](https://www.freshports.org/ports-mgmt/portshaker/).

The port has two `FLAVOR`, `idf4` and `idf3`. Choose one (if you are trying to
build an Arduino project, use `idf3`).

```console
cd /usr/ports/devel/xtensa-esp32-elf
make FLAVOR="idf3"
make install FLAVOR="idf3"
```

The files are installed under `${PREFIX}/xtensa-esp32-elf-idf3`, usually
`/usr/local/xtensa-esp32-elf-idf3`.

### `platformio` and `arduino-esp32`

```console
mkdir -p ~/.platformio/packages
cd ~/.platformio/packages
ln -s /usr/local/xtensa-esp32-elf-idf3 toolchain-xtensa32
```

Run `pio run` in the project directory.

```
> pio run -e esp32
Processing esp32 (platform: espressif32; framework: arduino; board:
esp32doit-devkit-v1)
---------------------------------------------------------------------------------------------------------------------------------------
Verbose mode can be enabled via `-v, --verbose` option
CONFIGURATION: https://docs.platformio.org/page/boards/espressif32/esp32doit-devkit-v1.html
PLATFORM: Espressif 32 (3.2.1) > DOIT ESP32 DEVKIT V1
HARDWARE: ESP32 240MHz, 320KB RAM, 4MB Flash
DEBUG: Current (esp-prog) External (esp-prog, iot-bus-jtag, jlink, minimodule,
olimex-arm-usb-ocd, olimex-arm-usb-ocd-h, olimex-arm-usb-tiny-h,
olimex-jtag-tiny, tumpa)
PACKAGES:
 - framework-arduinoespressif32 3.10006.210326 (1.0.6)
 - tool-esptoolpy 1.30000.201119 (3.0.0)
 - toolchain-xtensa32 2.50200.0 (5.2.0)
Converting Blink.ino
LDF: Library Dependency Finder -> http://bit.ly/configure-pio-ldf
LDF Modes: Finder ~ chain, Compatibility ~ soft
Found 28 compatible libraries
Scanning dependencies...
No dependencies
Building in release mode
Compiling .pio/build/esp32/src/Blink.ino.cpp.o
Compiling .pio/build/esp32/FrameworkArduino/Esp.cpp.o
Compiling .pio/build/esp32/FrameworkArduino/FunctionalInterrupt.cpp.o
Compiling .pio/build/esp32/FrameworkArduino/HardwareSerial.cpp.o
Compiling .pio/build/esp32/FrameworkArduino/IPAddress.cpp.o
...
```
### `esp-idf`

Set relevant environment variables, such as `IDF_PATH`.

Add `bin` directory of the package to `PATH` environment variable.

```console
export PATH=${PATH}:/usr/local/xtensa-esp32-elf-idf4/bin
```

If you have used the old (without `FLAVOR`) port, make sure to clean the
`build` directory.

```console
idf.py clean
```

Build the project as usual.

```console
idf.py all
```
