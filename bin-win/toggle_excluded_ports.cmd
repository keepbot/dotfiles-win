rem Modify Dynamic Port Range for Development Users
dism /online /get-features | find /i "Microsoft-Hyper-V" && (
rem Modify Dynamic Port Range
start /wait "" netsh int ipv4 set dynamicport tcp start=20000 num=16384
start /wait "" netsh int ipv4 set dynamicport udp start=20000 num=16384

rem Add Registry Key
start /wait "" reg add HKLM\SYSTEM\CurrentControlSet\Services\hns\State /v EnableExcludedPortRange /d 0 /f

goto :eof

)

rem Set range to default
start /wait "" netsh int ipv4 set dynamicport tcp start=49152 num=16384
start /wait "" netsh int ipv4 set dynamicport udp start=49152 num=16384

rem Remove Registry Key
start /wait "" reg delete HKLM\SYSTEM\CurrentControlSet\Services\hns\State /v EnableExcludedPortRange /f
