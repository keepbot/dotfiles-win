
function sonar_set_token
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Token
    )
    Set-Item -Path Env:SONAR_TOKEN -Value $Token
}

function sonar_build_sln
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_})]
        [string] $Path,
        [string] $Threads = '4'
    )
    build-wrapper-win-x86-64.exe --out-dir bw-output msbuild $Path /t:Clean;Rebuild /m:$Threads /p:Configuration=Release /p:Platform=x64 /verbosity:normal
}

function sonar_scan
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Organization,
        [Parameter(Mandatory=$true)]
        [string] $ProjectKey,
        [string] $Threads = '4'
    )

    $cmd  = "sonar-scanner.bat"
    $cmd += " -Dsonar.cfamily.build-wrapper-output=bw-output"
    $cmd += " -Dsonar.cfamily.threads=${Threads}"
    $cmd += " -Dsonar.host.url=https://sonarcloud.io"
    $cmd += " -Dsonar.organization=${Organization}"
    $cmd += " -Dsonar.projectKey=${ProjectKey}"
    $cmd += " -Dsonar.sources=."

    Invoke-Expression "$cmd"
}
