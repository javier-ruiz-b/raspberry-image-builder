#!/bin/sh

FAILED_STARTS_FOR_RECOVERY=10
FILE=/boot/initramfs-recovery/failed-startup-counter

if [ ! -f "$FILE" ]; then
    echo 0 > "$FILE"
fi

starts="$(cat "$FILE")"

if [ "$starts" -ge "$FAILED_STARTS_FOR_RECOVERY" ]; then
    SCRIPT_DIR="$(dirname "$(realpath $0)")"
    LOGS_DIR="$SCRIPT_DIR/logs"
    mkdir -p "$LOGS_DIR"
    i=1
    while true; do
        LOGFILE="$LOGS_DIR/recovery_$i.log"
        if [ ! -f $LOGFILE ]; then
            break
        fi
        i=$((i+1))
    done
    sh "$SCRIPT_DIR/recovery.sh" 2>&1 | tee "$LOGFILE"
else
    echo "$((starts+1))" > "$FILE"
fi
sync
