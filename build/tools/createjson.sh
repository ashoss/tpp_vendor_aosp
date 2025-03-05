#!/bin/bash
#
# Copyright (C) 2019-2023 crDroid Android Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Ensure all required arguments are passed
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <TARGET_DEVICE> <PRODUCT_OUT> <FILE_NAME>"
    exit 1
fi

TARGET_DEVICE=$1
PRODUCT_OUT=$2
FILE_NAME=$3
OUTPUT_FILE="$PRODUCT_OUT/$TARGET_DEVICE.json"

# Ensure the output directory exists
mkdir -p "$PRODUCT_OUT"

# Check if the directory is writable
if [[ ! -w "$PRODUCT_OUT" ]]; then
    echo "Warning: No write permissions for $PRODUCT_OUT"

    # Suggest an alternative writable directory
    ALT_DIR="$HOME/$TARGET_DEVICE-builds"
    mkdir -p "$ALT_DIR"

    if [[ -w "$ALT_DIR" ]]; then
        echo "You don't have permissions to write to $PRODUCT_OUT."
        echo "Using an alternative writable directory: $ALT_DIR"
        PRODUCT_OUT="$ALT_DIR"
        OUTPUT_FILE="$PRODUCT_OUT/$TARGET_DEVICE.json"
    else
        echo "Error: No writable directories found. Please run the script in a directory where you have write access."
        exit 1
    fi
fi

# Cleanup old file if it exists
if [[ -f "$OUTPUT_FILE" ]]; then
    rm "$OUTPUT_FILE"
fi

echo "Generating JSON file data for OTA support..."

# Check if the filename contains "UNOFFICIAL" and exit if true
if [[ "$FILE_NAME" == *"UNOFFICIAL"* ]]; then
    echo "Skipping JSON generation as the build is marked UNOFFICIAL."
    exit 0
fi

# Set romtype to OFFICIAL
ROM_TYPE="OFFICIAL"

# Ensure build.prop exists
BUILD_PROP="$PRODUCT_OUT/system/build.prop"
if [[ ! -f "$BUILD_PROP" ]]; then
    echo "Error: build.prop not found in $BUILD_PROP"
    exit 1
fi

# Extract required information
DATETIME=$(grep "ro.build.date.utc" "$BUILD_PROP" | cut -d'=' -f2)
if [[ -z "$DATETIME" ]]; then
    echo "Error: Unable to extract datetime from build.prop"
    exit 1
fi

FILENAME="$FILE_NAME"
ID=$(sha256sum "$PRODUCT_OUT/$FILE_NAME" | cut -d' ' -f1)
SIZE=$(stat -c "%s" "$PRODUCT_OUT/$FILE_NAME")

# Create JSON output
cat <<EOF > "$OUTPUT_FILE"
{
  "response": [
    {
      "datetime": $DATETIME,
      "filename": "$FILENAME",
      "id": "$ID",
      "romtype": "$ROM_TYPE",
      "size": $SIZE,
      "url": "https://sourceforge.net/projects/pixel-project/files/$TARGET_DEVICE/$FILE_NAME/download"
    }
  ]
}
EOF

echo "JSON file generated successfully at $OUTPUT_FILE"
