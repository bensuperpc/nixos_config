# ESP-IDF example

Hello world printing the chip, core count and flash size, for the ESP-IDF devshells
(`nix develop .#esp32c5`, `.#esp32c6` or `.#esp32p4`). Each shell sets `IDF_TARGET`; keeping
one build directory and `sdkconfig` per target lets you switch shells without `fullclean`:

```bash
nix develop .#esp32c6
cd tests/esp-idf
idf.py -B build/$IDF_TARGET -D SDKCONFIG=build/$IDF_TARGET/sdkconfig build
idf.py -B build/$IDF_TARGET -D SDKCONFIG=build/$IDF_TARGET/sdkconfig -p /dev/ttyACM0 flash monitor
```

Flashing needs access to the serial port (`dialout` group, or `uucp` on some distributions).
