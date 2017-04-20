# STM32F4 HAL

This project, available from [GitHub](https://github.com/xpacks/stm32f4-hal),
includes the STM32F4 HAL files.

## Version

* CMSIS Pack v2.11.0
* ST HAL v1.6.0

## Documentation

The latest STM documentation is available from
[STM32CubeF4](http://www.st.com/web/catalog/tools/FM147/CL1794/SC961/SS1743/LN1897/PF259243).

The latest CMSIS documentation is available from
[keil.com](http://www.keil.com/cmsis).

The list of latest packs is available from [keil.com](https://www.keil.com/dd2/pack/).

## Original files

The original files are available in the `originals` branch.

These files were extracted from `Keil.STM32F4xx_DFP.2.11.0.pack`.

To save space, only the following folders were preserved:

* Drivers/STM32F\?xx\_HAL\_Driver/

## Changes

* `stm32f4xx\_hal.h`: silence `-Wpadded`.

## Warnings

To silence warnings when compiling the HAL drivers, use:

```
-Wno-sign-conversion -Wno-padded -Wno-conversion -Wno-unused-parameter \
-Wno-bad-function-cast -Wno-sign-compare
```

## Tests

```
export PATH=/usr/local/gcc-arm-none-eabi-5_2-2015q4/bin:$PATH
bash ../../../scripts/run-tests.sh
```
