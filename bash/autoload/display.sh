#!/usr/bin/env bash

alias c='clear'

# Export DISPLAY variable. If local than it exports localhost, if remole it exports SSH Client
alias disp='source ~/.bin/export-display.sh'

# Export display for WSL:
if [[ $WSL_DISTRO_NAME ]]
then
    export DISPLAY=$(ip route | grep default | awk '{print $3}'):0.0
fi

set-display-one()
{
    #nvidia-settings --assign CurrentMetaMode="DPY-5: nvidia-auto-select @3840x2160 +0+0 {ViewPortIn=3840x2160, ViewPortOut=3840x2160+0+0}, DPY-2: nvidia-auto-select @3840x2160 +3840+0 {ViewPortIn=3840x2160, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}"
    # HDMI - Switchable graphics off
    #xrandr --output DP-1 --scale 2x2
    xrandr --output eDP1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --panning 3840x2160+0+0 

    # HDMI - Switchable graphics on
    #xrandr --output eDP1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --panning 3840x2160+0+0 --output HDMI2 --mode 1920x1080 --pos 3840x0 --rotate normal --scale 2x2 --right-of eDP1 --panning 3840x2160+3840+0
}

set-display()
{
    case $1 in
        reset )
            xrandr --output eDP1
            ;;
        hdmi1 )
            xrandr                          \
                --output eDP1               \
                --primary                   \
                --mode 3840x2160            \
                --pos 0x0                   \
                --rotate normal             \
                --panning 3840x2160+0+0     \
                --output HDMI1              \
                --mode 1920x1080            \
                --pos 3840x0                \
                --rotate normal             \
                --scale 2x2                 \
                --right-of eDP1             \
                --panning 3840x2160+3840+0
            ;;
        hdmi2 )
            xrandr                          \
                --output eDP1               \
                --primary                   \
                --mode 3840x2160            \
                --pos 0x0                   \
                --rotate normal             \
                --panning 3840x2160+0+0     \
                --output HDMI2              \
                --mode 1920x1080            \
                --pos 3840x0                \
                --rotate normal             \
                --scale 2x2                 \
                --right-of eDP1             \
                --panning 3840x2160+3840+0
            ;;
        dp3 )
            xrandr                          \
                --output eDP1               \
                --primary                   \
                --mode 3840x2160            \
                --pos 0x0                   \
                --rotate normal             \
                --panning 3840x2160+0+0     \
                --output DP3                \
                --mode 1920x1080            \
                --pos 3840x0                \
                --rotate normal             \
                --scale 2x2                 \
                --right-of eDP1             \
                --panning 3840x2160+3840+0
            ;;
        dp-4-dp-1 )
            xrandr                          \
                --output DP-4               \
                --primary                   \
                --mode 3840x2160            \
                --pos 0x0                   \
                --rotate normal             \
                --panning 3840x2160+0+0     \
                --output DP-1               \
                --mode 1920x1080            \
                --pos 3840x0                \
                --rotate normal             \
                --scale 2x2                 \
                --right-of DP-4             \
                --panning 3840x2160+3840+0
            ;;
        hdmi-1-2 )
            # xrandr                          \
            #     --output eDP-1-1            \
            #     --primary                   \
            #     --mode 3840x2160            \
            #     --pos 0x0                   \
            #     --rotate normal             \
            #     --panning 3840x2160+0+0     \
            #     --output HDMI-1-2           \
            #     --mode 1920x1080            \
            #     --pos 3840x0                \
            #     --rotate normal             \
            #     --scale 2x2                 \
            #     --right-of eDP-1-1          \
            #     --panning 3840x2160+3840+0
            # xrandr  --fb 7680x2160          \
            xrandr            \
                --output eDP-1-1            \
                --primary                   \
                --mode 3840x2160            \
                --pos 0x0                   \
                --rotate normal             \
                --panning 3840x2160+0+0     \
                --output HDMI-1-2           \
                --mode 1920x1080            \
                --pos 3840x0                \
                --rotate normal             \
                --scale 2x2                 \
                --right-of eDP-1-1          \
                --panning 3840x2160+3840+0
            ;;
        nvdp5dp2 )
            nvidia-settings --assign \
                CurrentMetaMode="DPY-5: nvidia-auto-select @3840x2160 +0+0 {ViewPortIn=3840x2160, ViewPortOut=3840x2160+0+0}, DPY-2: nvidia-auto-select @3840x2160 +3840+0 {ViewPortIn=3840x2160, ViewPortOut=1920x1080+0+0, ForceFullCompositionPipeline=On}"
            ;;
        dock-reset )
            xrandr                                                                 \
             --output eDP1      --auto --panning 3840x2160+0+0                     \
             --output DP2-2     --off                                              \
             --output DP2-3     --off                                              \
             --output DP1       --off                                              \
             --output DP2       --off                                              \
             --output DP2-1     --off                                              \
             --output DP3       --off                                              \
             --output HDMI1     --off                                              \
             --output HDMI2     --off                                              \
             --output HDMI3     --off                                              \
             --output VIRTUAL1  --off
            ;;
        dock )
            xrandr                                          \
             --output eDP1   --mode 3840x2160               \
             --pos 0x2160    --rotate normal --primary      \
             --output DP2-2  --mode 1920x1080               \
             --pos 0x0       --rotate normal --above eDP1   \
             --output DP2-3  --mode 1920x1080               \
             --pos 1920x0    --rotate normal --above eDP1
            ;;
        dock2 )
            # xrandr              --fb 11520x2160                                    \
            xrandr                                                                 \
             --output DP2-2     --mode 1920x1080  --crtc 1                         \
             --pos 0x0          --rotate normal                                    \
             --scale 2x2        --left-of eDP1    --panning 3840x2160+0+0          \
             --output eDP1      --mode 3840x2160  --crtc 0                         \
             --pos 3840x0       --rotate normal                                    \
             --primary                            --panning 3840x2160+3840+0       \
             --output DP2-3     --mode 1920x1080  --crtc 2                         \
             --pos 7680x0       --rotate normal                                    \
             --scale 2x2        --right-of eDP1   --panning 3840x2160+7680+0       \
             --output DP1       --off                                              \
             --output DP2       --off                                              \
             --output DP2-1     --off                                              \
             --output DP3       --off                                              \
             --output HDMI1     --off                                              \
             --output HDMI2     --off                                              \
             --output HDMI3     --off                                              \
             --output VIRTUAL1  --off
            ;;
        dock3 )
            # xrandr              --fb 11520x2160                                    \
            xrandr                                                                 \
             --output DP2-2     --mode 1920x1080  --crtc 1                         \
             --pos 0x0          --rotate normal                                    \
             --scale 2x2        --left-of eDP1    --panning 3840x2160+0+0          \
             --output eDP1      --mode 3840x2160  --crtc 0                         \
             --pos 3840x0       --rotate normal                                    \
             --primary                            --panning 3840x2160+3840+0       \
             --output DP2-3     --off                                              \
             --output DP1       --off                                              \
             --output DP2       --off                                              \
             --output DP2-1     --off                                              \
             --output DP3       --off                                              \
             --output HDMI1     --off                                              \
             --output HDMI2     --off                                              \
             --output HDMI3     --off                                              \
             --output VIRTUAL1  --off
            ;;
        * )
            echo "Unknown display configuration"
            ;;
    esac
}

