#!/bin/dash
set -eu

text_size=10
text_fg_color=00
text_bg_color=FF

raspivid \
    -w 1024 -h 768 -fps 15 -b 1200000 \
    -a 8 -a 1024 -ae $text_size,0x$text_fg_color,0x8080$text_bg_color -a "%d-%m-%Y %X" \
    -ex nightpreview -awb greyworld -t 0 --nopreview  \
    -l -o tcp://0.0.0.0:5000


# consumes more power:
# raspivid \
#     -w 1024 -h 768 -fps 15 -b 1200000 \
#     -a 8 -a 1024 -ae $text_size,0x$text_fg_color,0x8080$text_bg_color -a "%d-%m-%Y %X" \
#     -md 2 -ex auto -awb greyworld -t 0 -n \
#     -l -o tcp://0.0.0.0:5000

#Camera Modes:
# 0	automatic selection				
# 1	1920x1080	16:9	0.1-30fps	Partial	None
# 2	3280x2464	4:3	0.1-15fps	Full	None
# 3	3280x2464	4:3	0.1-15fps	Full	None
# 4	1640x1232	4:3	0.1-40fps	Full	2x2
# 5	1640x922	16:9	0.1-40fps	Full	2x2
# 6	1280x720	16:9	40-90fps	Partial	2x2
# 7	640x480	4:3	40-200fps1	Partial	2x2 

# -awb greyworld for NoIR