#!/usr/bin/env bash
case $1 in
    reset )
        xrandr --output eDP1
        ;;
    hdmi1 )
        xrandr --output eDP1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --panning 3840x2160+0+0 --output HDMI1 --mode 1920x1080 --pos 3840x0 --rotate normal --scale 2x2 --right-of eDP1 --panning 3840x2160+3840+0
        ;;
    hdmi2 )
        xrandr --output eDP1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --panning 3840x2160+0+0 --output HDMI2 --mode 1920x1080 --pos 3840x0 --rotate normal --scale 2x2 --right-of eDP1 --panning 3840x2160+3840+0
        ;;
    dp3 )
        xrandr --output eDP1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --panning 3840x2160+0+0 --output DP3 --mode 1920x1080 --pos 3840x0 --rotate normal --scale 2x2 --right-of eDP1 --panning 3840x2160+3840+0
        ;;
    dp4dp1 )
        xrandr --output DP-4 --primary --mode 3840x2160 --pos 0x0 --rotate normal --panning 3840x2160+0+0 --output DP-1 --mode 1920x1080 --pos 3840x0 --rotate normal --scale 2x2 --right-of DP-4 --panning 3840x2160+3840+0
        ;;
    nvdp5dp2 )
        nvidia-settings --assign \
            CurrentMetaMode="DPY-5: nvidia-auto-select @3840x2160 +0+0 {ViewPortIn=3840x2160, ViewPortOut=3840x2160+0+0}, DPY-2: nvidia-auto-select @3840x2160 +3840+0 {ViewPortIn=3840x2160, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}"
        ;;
    dock )
        xrandr --fb 7680x4320                                                                                                       \
         --output eDP1  --mode 3840x2160 --pos 1920x2160 --rotate normal --primary                    --panning 3840x2160+1920+2160 \
         --output DP2-2 --mode 1920x1080 --pos 0x0       --rotate normal --scale 2x2 --above    eDP1  --panning 3840x2160+0+0       \
         --output DP2-3 --mode 1920x1080 --pos 3840x0    --rotate normal --scale 2x2 --right-of DP2-2 --panning 3840x2160+3840+0
        ;;
    * )
        echo "Unknown display configuration"
        ;;
esac

