#!/bin/bash
set -euo pipefail
./v4l2rtspserver -v 

# ./v4l2rtspserver [-v[v]] [-Q queueSize] [-O file] \
# 		       [-I interface] [-P RTSP port] [-p RTSP/HTTP port] [-m multicast url] [-u unicast url] [-M multicast addr] [-c] [-t timeout] \
# 		       [-r] [-s] [-W width] [-H height] [-F fps] [device1] [device2]
# 	 -v       : verbose
# 	 -vv      : very verbose
# 	 -Q length: Number of frame queue  (default 10)
# 	 -O output: Copy captured frame to a file or a V4L2 device
	 
# 	 RTSP options :
# 	 -I addr  : RTSP interface (default autodetect)
# 	 -P port  : RTSP port (default 8554)
# 	 -p port  : RTSP over HTTP port (default 0)
# 	 -U user:password : RTSP user and password
# 	 -R realm  : use md5 password 'md5(<username>:<realm>:<password>')
# 	 -u url   : unicast url (default unicast)
# 	 -m url   : multicast url (default multicast)
# 	 -M addr  : multicast group:port (default is random_address:20000)
# 	 -c       : don't repeat config (default repeat config before IDR frame)
# 	 -t secs  : RTCP expiration timeout (default 65)
# 	 -S[secs] : HTTP segment duration (enable HLS & MPEG-DASH)
# 	 -x <sslkeycert>  : enable RTSPS & SRTP

# 	 V4L2 options :
# 	 -r       : V4L2 capture using read interface (default use memory mapped buffers)
# 	 -w       : V4L2 capture using write interface (default use memory mapped buffers)
# 	 -B       : V4L2 capture using blocking mode (default use non-blocking mode)
# 	 -s       : V4L2 capture using live555 mainloop (default use a separated reading thread)
# 	 -f       : V4L2 capture using current capture format (-W,-H are ignored)
# 	 -fformat : V4L2 capture using format (-W,-H are used)
# 	 -W width : V4L2 capture width (default 640)
# 	 -H height: V4L2 capture height (default 480)
# 	 -F fps   : V4L2 capture framerate (default 25, 0 disable setting framerate)
# 	 -G <w>x<h>[x<f>] : V4L2 capture format (default 0x0x25)
	 
# 	 ALSA options :
# 	 -A freq    : ALSA capture frequency and channel (default 44100)
# 	 -C channels: ALSA capture channels (default 2)
# 	 -a fmt     : ALSA capture audio format (default S16_LE)
	 
# 	 device   : V4L2 capture device and/or ALSA device (default /dev/video0)

#######
# Example Frigate:
#
# cameras:
#   rtspcam1:
#     ffmpeg:
#       inputs:
#         - path: "rtsp://10.0.0.71:8554/unicast"
#           roles:
#             - detect
#             - rtmp