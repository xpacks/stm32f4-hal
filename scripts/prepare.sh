#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

#
# Copyright (c) 2015 Liviu Ionescu.
# This file is part of the xPacks project (https://xpacks.github.io).
#

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
RELEASE_VERSION="1110"

FAMILY="STM32F4"
GITHUB_PROJECT="xpacks/stm32f4-hal"

RELEASE_NAME="stm32cube_fw_f4_v${RELEASE_VERSION}"
ARCHIVE_NAME="${RELEASE_NAME}.zip"
ARCHIVE_URL="https://sourceforge.net/projects/micro-os-plus/files/Vendor%20Archives/STM32/${ARCHIVE_NAME}"

LOCAL_ARCHIVE_FILE="/tmp/xpacks/${ARCHIVE_NAME}"

echo "Cleaning previous files..."
for f in *
do
  if [ "${f}" == "scripts" ]
  then
    :
  else
    rm -rf "${f}"
  fi
done

if [ ! -f "${LOCAL_ARCHIVE_FILE}" ]
then
  mkdir -p $(dirname ${LOCAL_ARCHIVE_FILE})
  curl -o "${LOCAL_ARCHIVE_FILE}" -L "${ARCHIVE_URL}"
fi

echo "Unpacking '${ARCHIVE_NAME}'..."
unzip -q "${LOCAL_ARCHIVE_FILE}"
mv STM32Cube_FW_*/Drivers .

echo "Removing unnecessary files..."
rm -rf \
Drivers/BSP/ \
Drivers/CMSIS/ \
Drivers/STM32F?xx_HAL_Driver/*.chm \
STM32Cube_* \

find . -name '*.exe' -exec rm \{} \;

echo "Creating README.md..."
cat <<EOF >README.md
# ${FAMILY} HAL

This project, available from [GitHub](https://github.com/${GITHUB_PROJECT}),
includes the ${FAMILY} HAL files.

## Version

* v${RELEASE_VERSION}

## Documentation

The latest STM documentation is available from
[STM32CubeF4](http://www.st.com/web/catalog/tools/FM147/CL1794/SC961/SS1743/LN1897/PF259243).

## Original files

The original files are available in the \`originals\` branch.

These files were extracted from \`${ARCHIVE_NAME}\`.

To save space, only the following folder was copied:

* STM32Cube\_FW\_*/Drivers

and from it, the following folders/files were removed:

* all non-portable *.exe files
* Drivers/BSP/
* Drivers/CMSIS/
* Drivers/STM32F?xx\_HAL\_Driver/*.chm

## Changes

* none.

EOF

echo
echo Check if ok and when ready, issue: \`git commit -m ${ARCHIVE_NAME}\`
