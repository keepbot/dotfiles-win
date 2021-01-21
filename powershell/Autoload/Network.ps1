<#
.SYNOPSIS
Network scripts.

.DESCRIPTION
Network scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


if (Get-Command dig.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:myip}   = { dig.exe +short myip.opendns.com `@resolver1.opendns.com }
    function digga
    {
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory=$true)]
            [ValidatePattern('\w+\.\w+')]
            [string] $Domain,
            [ValidatePattern('^\d+\.\d+\.\d+\.\d+$')]
            [string] $DNSServer
        )

        $cmd  = "dig.exe"

        if ($DNSServer) {
            $cmd += " ``@${DNSServer}"
        }

        $cmd += "  +nocmd"
        $cmd += " ${Domain}"
        $cmd += " any +multiline +noall +answer"

        Invoke-Expression "${cmd}"
    }

    function digga_full
    {
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory=$true)]
            [ValidatePattern('\w+\.\w+')]
            [string] $Domain,
            [ValidatePattern('^\d+\.\d+\.\d+\.\d+$')]
            [string] $DNSServer
        )

        $cmd  = "dig.exe"

        if ($DNSServer) {
            $cmd += " ``@${DNSServer}"
        }

        $cmd += " ${Domain}"
        $cmd += " any +multiline"

        Invoke-Expression "${cmd}"
    }
}
${function:ipif} = {if ($($args[0])) {curl ipinfo.io/"$($args[0].ToString())"} else {curl ipinfo.io}}

${function:localip} = { Get-NetIPAddress | Format-Table }

${function:urlencode} = { python.exe -c "import sys, urllib.parse; print(urllib.parse.quote(str(sys.argv[1])));" @args }

${function:net_show_excluded} = { netsh interface ipv4 show excludedportrange protocol=tcp }

${function:net_show_connects} = { netstat -ano }

function List-ServersSortedFastest
{
    param
    (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string[]] $ServerList,
        $TimeoutMillisec = 1000
    )

    begin
    {
        # Internal Buffer
        [Collections.ArrayList]$buffer = @()

        # Error codes to text translation
        $StatusCode_ReturnValue =
        @{
            0='Success'
            11001='Buffer Too Small'
            11002='Destination Net Unreachable'
            11003='Destination Host Unreachable'
            11004='Destination Protocol Unreachable'
            11005='Destination Port Unreachable'
            11006='No Resources'
            11007='Bad Option'
            11008='Hardware Error'
            11009='Packet Too Big'
            11010='Request Timed Out'
            11011='Bad Request'
            11012='Bad Route'
            11013='TimeToLive Expired Transit'
            11014='TimeToLive Expired Reassembly'
            11015='Parameter Problem'
            11016='Source Quench'
            11017='Option Too Big'
            11018='Bad Destination'
            11032='Negotiating IPSEC'
            11050='General Failure'
        }

        # Convert numeric return value into friendly text
        $statusFriendlyText = @{
            Name = 'Status'
            Expression = { $StatusCode_ReturnValue[([int]$_.StatusCode)] }
        }

        # When status code is 0 we ssume that IP is online
        $IsOnline = @{
            Name = 'Online'
            Expression = { $_.StatusCode -eq 0 }
        }

        # Do DNS resolution when system responds to ping
        $DNSName = @{
            Name = 'DNSName'
            Expression = { if ($_.StatusCode -eq 0) {
                    if ($_.Address -like '*.*.*.*')
                    { [Net.DNS]::GetHostByAddress($_.Address).HostName  }
                    else
                    { [Net.DNS]::GetHostByName($_.Address).HostName  }
                }
            }
        }
    }

    process
    {
        $ServerList | ForEach-Object {
            $null = $buffer.Add($_)
        }
    }

    end
    {
        # Convert list of computers into a WMI query string
        $query = $buffer -join "' or Address='"

        # Ping the specified servers with a given timeout (milliseconds)
        Get-CimInstance -ClassName Win32_PingStatus -Filter "(Address='$query') and timeout=$TimeoutMillisec" |
        Select-Object -Property Address, $IsOnline, $DNSName, $statusFriendlyText
    }
}

function Get-FastestServerInList
{
    param
    (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string[]] $ServerList,
        $TimeoutMillisec = 1000
    )

    begin
    {
        # Internal Buffer
        [Collections.ArrayList]$buffer = @()
    }

    process
    {
        $ServerList | ForEach-Object {
            $null = $buffer.Add($_)
        }
    }

    end
    {
        # Convert list of computers into a WMI query string
        $query = $buffer -join "' or Address='"

        # Ping the specified servers with a given timeout (milliseconds)
        $SortedServers = Get-CimInstance -ClassName Win32_PingStatus -Filter "(Address='$query') and timeout=$TimeoutMillisec" |
        Select-Object -Property Address
        $SortedServers[0]
    }
}

function Get-NearestDC
{
    param
    (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string] $DomainName
    )
    $ips = @()
    [System.Net.Dns]::GetHostAddresses("${DomainName}") | Foreach-Object { $ips += $_.IPAddressToString }
    Get-FastestServerInList $ips
}

function Get-NearestDC_IP
{
    param
    (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string] $DomainName
    )
    (Get-NearestDC $DomainName).Address
}
