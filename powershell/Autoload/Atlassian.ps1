<#
.SYNOPSIS
Atlassian scripts.

.DESCRIPTION
Atlassian scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function bamboo_get_ami
{
    if ($args.Count -ne 2)
    {
        Write-Host "Usage: bamboo_get_ami <Bamboo_version> <filter(windows, linux, PV, HVM, image)>"
    }
    else
    {
        $BAMBOO_VERSION=$args[0]

        Write-Host "AWS AMI for Bamboo v${BAMBOO_VERSION}:"
        [xml]$pom_file   = (New-Object System.Net.WebClient).DownloadString("https://maven.atlassian.com/content/groups/public/com/atlassian/bamboo/atlassian-bamboo/${BAMBOO_VERSION}/atlassian-bamboo-${BAMBOO_VERSION}.pom")
        $ELASTIC_VERSION = ${pom_file}.project.properties.'elastic-image.version'

        Write-Host "Elastic bamboo version is $ELASTIC_VERSION"
        $amis = Invoke-RestMethod https://maven.atlassian.com/content/groups/public/com/atlassian/bamboo/atlassian-bamboo-elastic-image/${ELASTIC_VERSION}/atlassian-bamboo-elastic-image-${ELASTIC_VERSION}.ami
        $amis.tostring() -split "[`r`n]" | Select-String "image." | Select-String $args[1] | Sort-Object | ForEach-Object {
            $TempCharAray = $_.ToString().Split("=")
            Write-Host -ForegroundColor Yellow "$($TempCharAray[0]) `t$($TempCharAray[1])"
        }

        Write-Host "`n`tREMEMBER: Use the Image from the appropriate region!" -ForegroundColor Red
    }
}

function bamboo_get_current_version
{
    $Responce = (Invoke-Webrequest https://my.atlassian.com/download/feeds/current/bamboo.json).Content
    $Responce = $Responce.Substring(10)
    $ResponceLength = $Responce.Length
    $Responce = $Responce.Substring(0, $ResponceLength - 1)
    return ($Responce | ConvertFrom-Json)[0].version
}

function bamboo_generate_specs()
{
    [CmdletBinding()]
    param
    (
        ## Error message works since Powershell version 6
        # [ValidatePattern(
        #     '(\d+)\.(\d+)\.(\d+)$',
        #     ErrorMessage = "Bamboo version should math this pattern: N.N.N"
        # )]

        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        # [ValidateScript({$_ -match '^(\d+)\.(\d+)\.(\d+)$'})]
        [ValidatePattern('^\d+\.\d+\.\d+$')]
        [string] $Version,

        # [Parameter(Mandatory=$true)]
        # [string] $ArtifactId,

        [Parameter(Mandatory=$true)]
        [ValidatePattern('^\w+\.\w+\.\w+')]
        [string] $Package

    )
    Write-Host "`t Generating Bamboo-Specs for version $Version" -ForegroundColor Yellow

    $ArtifactId = $($($Package -replace "^\w+\.\w+\.","") -replace "\.","-")

    if (Get-Command mvn -ErrorAction SilentlyContinue | Test-Path)
    {
        # Simplest:
        # mvn archetype:generate -DarchetypeGroupId=com.atlassian.bamboo -DarchetypeArtifactId=bamboo-specs-archetype -DarchetypeVersion=7.0.4

        # Custom
        $cmd  = "cmd /c '"
        $cmd += "mvn archetype:generate -B"
        $cmd += " -DarchetypeGroupId=com.atlassian.bamboo"
        $cmd += " -DarchetypeArtifactId=bamboo-specs-archetype"
        $cmd += " -DarchetypeVersion=${Version}"
        $cmd += " -DgroupId=com.atlassian.bamboo"
        $cmd += " -DartifactId=${ArtifactId}"
        $cmd += " -Dversion=1.0.0-SNAPSHOT"
        $cmd += " -Dpackage=${Package}"
        $cmd += " -Dtemplate=minimal"
        $cmd += "'"

        # Write-Host "`t Maven cmd: $cmd`n" -ForegroundColor Yellow
        Invoke-Expression "$cmd"
    }
    else
    {
        Write-Host "ERROR: mvn not found..." -ForegroundColor Red
        Write-Host "ERROR: Maven should be installed and mvn.exe added to the %PATH% env" -ForegroundColor Red
    }
}

function atlassian_get_all_ip
{
    $Responce = (Invoke-Webrequest https://ip-ranges.atlassian.com/).Content
    return ($Responce | ConvertFrom-Json).items.cidr
}

${function:ssh-bamboo-agent} = { ssh -i ~/.ssh/elasticbamboo.pk @args }
