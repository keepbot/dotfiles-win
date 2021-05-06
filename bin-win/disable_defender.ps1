Write-Host 'Disable Windows Defender Real-time protection'
cmd /c 'reg delete "HKLM\Software\Policies\Microsoft\Windows Defender" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d "1" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpEnablePus" /t REG_DWORD /d "0" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" /v "SpynetReporting" /t REG_DWORD /d "0" /f'
cmd /c 'reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" /v "SubmitSamplesConsent" /t REG_DWORD /d "0" /f'

Write-Host 'Disable Windows Defender Logging'
cmd /c 'reg add "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f'
cmd /c 'reg add "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f'

Write-Host 'Disable WD Tasks'
cmd /c 'schtasks /Change /TN "Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /Disable'
cmd /c 'schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable'
cmd /c 'schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable'
cmd /c 'schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable'
cmd /c 'schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable'

Write-Host 'Disable Windows Defender systray icon'
cmd /c 'reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "Windows Defender" /f'
cmd /c 'reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows Defender" /f'
cmd /c 'reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "WindowsDefender" /f'
# To also disable Windows Defender Security Center include this:
# cmd /c 'reg add "HKLM\System\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "4" /f'

Write-Host 'Remove Windows Defender context menu'
cmd /c 'reg delete "HKCR\*\shellex\ContextMenuHandlers\EPP" /f'
cmd /c 'reg delete "HKCR\Directory\shellex\ContextMenuHandlers\EPP" /f'
cmd /c 'reg delete "HKCR\Drive\shellex\ContextMenuHandlers\EPP" /f'

Write-Host 'Disable Windows Defender services'
cmd /c 'reg add "HKLM\System\CurrentControlSet\Services\WdBoot" /v "Start" /t REG_DWORD /d "4" /f'
cmd /c 'reg add "HKLM\System\CurrentControlSet\Services\WdFilter" /v "Start" /t REG_DWORD /d "4" /f'
cmd /c 'reg add "HKLM\System\CurrentControlSet\Services\WdNisDrv" /v "Start" /t REG_DWORD /d "4" /f'
cmd /c 'reg add "HKLM\System\CurrentControlSet\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f'
cmd /c 'reg add "HKLM\System\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f'
cmd /c 'reg add "HKLM\System\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "4" /f'

Write-Host 'Setting relaxed Windows Defender preferences'
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction Ignore;
Set-MpPreference -DisableBehaviorMonitoring $true -ErrorAction Ignore;
Set-MpPreference -DisableBlockAtFirstSeen $true -ErrorAction Ignore;
Set-MpPreference -DisableIOAVProtection $true -ErrorAction Ignore;
Set-MpPreference -DisablePrivacyMode $true -ErrorAction Ignore;
Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true -ErrorAction Ignore;
Set-MpPreference -DisableArchiveScanning $true -ErrorAction Ignore;
Set-MpPreference -DisableIntrusionPreventionSystem $true -ErrorAction Ignore;
Set-MpPreference -DisableScriptScanning $true -ErrorAction Ignore;
Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction Ignore;
Set-MpPreference -MAPSReporting 0 -ErrorAction Ignore;
Set-MpPreference -HighThreatDefaultAction 6 -Force -ErrorAction Ignore;
Set-MpPreference -ModerateThreatDefaultAction 6 -ErrorAction Ignore;
Set-MpPreference -LowThreatDefaultAction 6 -ErrorAction Ignore;
Set-MpPreference -SevereThreatDefaultAction 6 -ErrorAction Ignore;
