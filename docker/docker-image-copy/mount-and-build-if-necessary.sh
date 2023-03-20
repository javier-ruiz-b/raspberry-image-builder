#!/bin/bash
set -euxo pipefail

compressed_file="$1"
result_file="$2"

rm -f "$result_file"

extracted_file="$(echo "$compressed_file" | cut -d. -f1).img"
if [ ! -f "$extracted_file" ]; then
    /build-basis-image.sh "$compressed_file" "$extracted_file"
fi

echo "Copying image"
cp "$extracted_file" "$result_file"
/mount.sh $MOUNT_POINT "$result_file"
