<#
.SYNOPSIS
Sonar scripts.

.DESCRIPTION
Sonar scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function sonar_set_token
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Token
    )
    Set-Item -Path Env:SONAR_TOKEN -Value $Token
}

function sonar_run_msbuild_cpp
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_})]
        [string] $Path,
        [string] $Threads = '4',
        [string] $WinSDK = '8.1'
    )

    if (-Not (Get-Command build-wrapper-win-x86-64.exe -ErrorAction SilentlyContinue | Test-Path))
    {
        Write-Host `
            "ERROR: build-wrapper-win-x86-64.exe wasn't found. Please download it from https://sonarcloud.io/ and add it to `$PATH. Exiting..." `
            -ForegroundColor Red
        return
    }

    Set-VC-Vars-All -SDK $WinSDK
    build-wrapper-win-x86-64.exe --out-dir bw-output msbuild $Path /t:Clean;Rebuild /m:$Threads /p:Configuration=Release /p:Platform=x64 /verbosity:normal
}

function sonar_scan_ormco_cpp
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Organization,
        [Parameter(Mandatory=$true)]
        [string] $ProjectKey,
        [string] $Language = 'cpp',
        [string] $Threads = '4'
    )

    if (-Not (Get-Command sonar-scanner.bat -ErrorAction SilentlyContinue | Test-Path))
    {
        Write-Host `
            "ERROR: sonar-scanner.bat wasn't found. Please download it from https://sonarcloud.io/ and add it to `$PATH. Exiting..." `
            -ForegroundColor Red
        return
    }

    switch ($Language)
    {
        'maven'
        {
            $cmd  = "mvn verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar"
        }
        'gradle'
        {
            $cmd  = "./gradlew sonarqube"
        }
        'dotnet'
        {
            $cmd  = 'dotnet sonarscanner begin /o:"ormcornd" /k:"ormcornd_alignerweb-api" /d:sonar.host.url="https://sonarcloud.io"; '
            $cmd  = 'dotnet build -c release; '
            $cmd  = 'dotnet sonarscanner end'
        }
        'cpp'
        {
            $cmd  = "sonar-scanner.bat"
            $cmd += " -Dsonar.cfamily.build-wrapper-output=bw-output"
            $cmd += " -Dsonar.cfamily.threads=${Threads}"
            $cmd += " -Dsonar.host.url=https://sonarcloud.io"
            $cmd += " -Dsonar.organization=${Organization}"
            $cmd += " -Dsonar.projectKey=${ProjectKey}"
            $cmd += " -Dsonar.sources=."
        }
        Default
        {
            $cmd  = "sonar-scanner.bat"
            $cmd += " -Dsonar.host.url=https://sonarcloud.io"
            $cmd += " -Dsonar.organization=${Organization}"
            $cmd += " -Dsonar.projectKey=${ProjectKey}"
            $cmd += " -Dsonar.sources=."
        }
    }

    Invoke-Expression "$cmd"
}
