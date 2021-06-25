#!/bin/bash
set -euxo pipefail

zip_file="$1"
result_file="$2"

rm -f "$result_file"

img_file="${zip_file%%.*}.img"
if [ ! -f "$img_file" ]; then
    /build-basis-image.sh "$zip_file"
fi

echo "Copying image"
cp $img_file "$result_file"
/mount.sh $MOUNT_POINT "$result_file"
