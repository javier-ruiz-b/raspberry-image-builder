#!/bin/sh

width=$1
height=$2
cameras=$3

echo "(($width * $height * 1.5 * 9 + 270480) / 1048576.0) * $cameras + 30" | bc
