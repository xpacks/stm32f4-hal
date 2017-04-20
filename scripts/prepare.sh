#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

#
# Copyright (c) 2015 Liviu Ionescu.
# This file is part of the xPacks project (https://xpacks.github.io).
#

# http://www.keil.com/dd2/pack/

# Archives are to be downloaded from:
# http://www.keil.com/pack/Keil.STM32F4xx_DFP.x.x.x.pack

# https://sourceforge.net/projects/micro-os-plus/files/Vendor%20Archives/STM32/

# RELEASE_VERSION="100"
# RELEASE_VERSION="110"
# RELEASE_VERSION="120"
# RELEASE_VERSION="130"
# RELEASE_VERSION="140"
# RELEASE_VERSION="150"
# RELEASE_VERSION="160"
# RELEASE_VERSION="170"
# RELEASE_VERSION="180"
# RELEASE_VERSION="190"
# RELEASE_VERSION="1100"
# RELEASE_VERSION="1110"
# RELEASE_VERSION="1.12.0"
# RELEASE_VERSION="1.13.0"
# RELEASE_VERSION="1.14.0"

# Switch to Keil CMSIS Pack
RELEASE_VERSION="2.11.0"

FAMILY="STM32F4"
GITHUB_PROJECT="xpacks/stm32f4-hal"

# RELEASE_VERSION_COMPACT=$(echo ${RELEASE_VERSION} | sed 's/\.//g')
# RELEASE_NAME="stm32cube_fw_f4_v${RELEASE_VERSION_COMPACT}"
# RELEASE_NAME="en.stm32cubef4_v${RELEASE_VERSION}"

# ARCHIVE_NAME="${RELEASE_NAME}.zip"
# ARCHIVE_URL="https://sourceforge.net/projects/micro-os-plus/files/Vendor%20Archives/STM32/${ARCHIVE_NAME}"

NAME_PREFIX="Keil.${FAMILY}xx_DFP"
ARCHIVE_NAME="${NAME_PREFIX}.${RELEASE_VERSION}.pack"
ARCHIVE_URL="http://www.keil.com/pack/${ARCHIVE_NAME}"

LOCAL_ARCHIVE_FILE="/tmp/xpacks/${ARCHIVE_NAME}"

BRANCH_NAME="$(git symbolic-ref -q --short HEAD)"
if [ "${BRANCH_NAME}" != "originals" ]
then
  echo "Run this only on the 'originals' branch"
  exit 1
fi

echo "Cleaning previous files..."
for f in *
do
  if [ -d "${f}" ]
  then
    if [ "${f}" == "scripts" -o "${f}" == "test" ]
    then
      :
    else
      rm -rf "${f}"
    fi
  fi
done

rm -rf *.pdsc Release_notes.html

if [ ! -f "${LOCAL_ARCHIVE_FILE}" ]
then
  mkdir -p $(dirname ${LOCAL_ARCHIVE_FILE})
  curl -o "${LOCAL_ARCHIVE_FILE}" -L "${ARCHIVE_URL}"
fi

echo "Unpacking '${ARCHIVE_NAME}'..."
mkdir -p tmp
(cd tmp; unzip -q "${LOCAL_ARCHIVE_FILE}")

# mv STM32Cube_FW_*/Drivers .

echo "Cherry picking the inteesting files..."
mkdir -p Drivers
mv tmp/Drivers/STM32F?xx_HAL_Driver Drivers

echo "Removing unnecessary files..."
rm -rf \
tmp \
Drivers/STM32F?xx_HAL_Driver/*.chm \

find . -name '*.exe' -exec rm \{} \;

HAL_VERSION="$(cat Drivers/STM32F?xx_HAL_Driver/inc/stm32f?xx_hal.h | grep '@version' | sed 's/.*V//')"

echo "Creating README.md..."
cat <<EOF >README.md
# ${FAMILY} HAL

This project, available from [GitHub](https://github.com/${GITHUB_PROJECT}),
includes the ${FAMILY} HAL files.

## Version

* CMSIS Pack v${RELEASE_VERSION}
* ST HAL v${HAL_VERSION}

## Documentation

The latest STM documentation is available from
[STM32CubeF4](http://www.st.com/web/catalog/tools/FM147/CL1794/SC961/SS1743/LN1897/PF259243).

The latest CMSIS documentation is available from
[keil.com](http://www.keil.com/cmsis).

The list of latest packs is available from [keil.com](https://www.keil.com/dd2/pack/).

## Original files

The original files are available in the \`originals\` branch.

These files were extracted from \`${ARCHIVE_NAME}\`.

To save space, only the following folders were preserved:

* Drivers/STM32F\?xx\_HAL\_Driver/

## Changes

* none.

EOF

echo
echo Check if ok and when ready, issue:
echo git add -A
echo git commit -m ${ARCHIVE_NAME}
echo New HAL version ${HAL_VERSION}
