# http://xkcd.com/530/
Set-Alias mute Set-SoundMute
Set-Alias unmute Set-SoundUnmute

# Power
${function:Set-Power-Max}       = { powercfg.exe /SETACTIVE SCHEME_MIN }
${function:Set-Power-Balanced}  = { powercfg.exe /SETACTIVE SCHEME_BALANCED }
${function:Set-Power-Min}       = { powercfg.exe /SETACTIVE SCHEME_MAX }
${function:Add-Power-ULT}       = { powercfg.exe -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 }
