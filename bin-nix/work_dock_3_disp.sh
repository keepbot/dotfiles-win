#!/bin/sh
xrandr --fb 7680x4320                                                                                                       \
 --output eDP1  --mode 3840x2160 --pos 1920x2160 --rotate normal --primary                    --panning 3840x2160+1920+2160 \
 --output DP2-2 --mode 1920x1080 --pos 0x0       --rotate normal --scale 2x2 --above eDP1     --panning 3840x2160+0+0       \
 --output DP2-3 --mode 1920x1080 --pos 3840x0    --rotate normal --scale 2x2 --right-of DP2-2 --panning 3840x2160+3840+0

