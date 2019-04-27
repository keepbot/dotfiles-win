# http://xkcd.com/530/
Set-Alias mute Set-SoundMute
Set-Alias unmute Set-SoundUnmute

# Power
${function:Set-Power-Max}       = { powercfg.exe /SETACTIVE SCHEME_MIN }
${function:Set-Power-Balanced}  = { powercfg.exe /SETACTIVE SCHEME_BALANCED }
${function:Set-Power-Min}       = { powercfg.exe /SETACTIVE SCHEME_MAX }
