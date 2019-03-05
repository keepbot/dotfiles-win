#!/bin/sh

#nvidia-settings --assign CurrentMetaMode="DPY-5: nvidia-auto-select @3840x2160 +0+0 {ViewPortIn=3840x2160, ViewPortOut=3840x2160+0+0}, DPY-2: nvidia-auto-select @3840x2160 +3840+0 {ViewPortIn=3840x2160, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}"
# HDMI - Switchable graphics off
#xrandr --output DP-1 --scale 2x2
xrandr --output eDP1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --panning 3840x2160+0+0 

# HDMI - Switchable graphics on
#xrandr --output eDP1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --panning 3840x2160+0+0 --output HDMI2 --mode 1920x1080 --pos 3840x0 --rotate normal --scale 2x2 --right-of eDP1 --panning 3840x2160+3840+0

