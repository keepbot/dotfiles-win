<#
.SYNOPSIS
Java scripts.

.DESCRIPTION
Java scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Get-JavaList
{
    <#
    .SYNOPSIS
        List installed Java versions on current PC.
    .DESCRIPTION
        List installed Java versions on current PC.
    .EXAMPLE
        Get-JavaList
    .INPUTS
        None
    .OUTPUTS
        Validated Java Kits Array
    .NOTES
        Written by: Dmitry Ivanov
    #>
    $javaBases = @(
        'C:\Program Files\Java\'
        'C:\Program Files\OpenJDK\'
        'C:\Program Files (x86)\Java\'
        'C:\Program Files (x86)\OpenJDK\'
    )

    $javas = @()
    foreach ($javaBase in $javaBases)
    {
        if (Test-Path $javaBase)
        {
            $((Get-ChildItem $javaBase).FullName | ForEach-Object { $javas += $_ })
        }
    }

    $javasValidated = @()
    foreach ($java in $javas)
    {
        if (Test-Path $java)
        {
            $javasValidated  += $java
        }
    }

    return $javasValidated
}

function Find-Java
{
    Write-Host "List of Java Kits on this PC:"
    return Get-JavaList
}


function Set-Java
{
    <#
    .SYNOPSIS
        Enable to use particular version of JAVA within current session.
    .DESCRIPTION
        Enable to use particular version of JAVA within current session.
    .EXAMPLE
        Set-Java
    .INPUTS
        Note
    .OUTPUTS
        None
    .NOTES
        Written by: Dmitry Ivanov
    #>
    $ChoosenJavaVersion = Select-From-List $(Get-JavaList) "Java path"
    [Environment]::SetEnvironmentVariable("JAVA_HOME", ${ChoosenJavaVersion}, "Machine")
    $env:JAVA_HOME = ${ChoosenJavaVersion}
    $env:PATH = "${env:JAVA_HOME}\bin;${env:PATH}"
}

function ormco_gen_aligners_reports
{
    [CmdletBinding()]
    param
    (
        # [Parameter(Mandatory = $True)]
        # [string]$PathToJar,
        [Parameter(Mandatory = $True)]
        [string]$ReportName,
        [string]$ReportSuffix
    )
    mvn clean install
    $cmd  = "cmd /c '"
    $cmd += "java -cp ./target/aligners-reports.jar "
    $cmd += "-Dloader.main=com.ormco.aligners.reports.RunSQLReport "
    $cmd += "org.springframework.boot.loader.PropertiesLauncher "
    $cmd += "--report=${ReportName} "
    $cmd += "--output=C:\Temp\${ReportName}${ReportSuffix}.xlsx"
    $cmd += "'"
    Invoke-Expression "${cmd}"
}
