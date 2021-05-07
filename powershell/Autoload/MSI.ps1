<#
.SYNOPSIS
MSI scripts.

.DESCRIPTION
MSI scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Get-MSI-Upgrade-Codes
{
    $wmipackages = Get-WmiObject -Class win32_product
    $wmiproperties = gwmi -Query "SELECT ProductCode,Value FROM Win32_Property WHERE Property='UpgradeCode'"
    $packageinfo = New-Object System.Data.Datatable
    [void]$packageinfo.Columns.Add("Name")
    [void]$packageinfo.Columns.Add("ProductCode")
    [void]$packageinfo.Columns.Add("UpgradeCode")

    foreach ($package in $wmipackages)
    {
        $foundupgradecode = $false # Assume no upgrade code is found

        foreach ($property in $wmiproperties)
        {
            if ($package.IdentifyingNumber -eq $property.ProductCode)
            {
               [void]$packageinfo.Rows.Add($package.Name,$package.IdentifyingNumber, $property.Value)
               $foundupgradecode = $true
               break
            }
        }

        if (-Not ($foundupgradecode))
        {
             # No upgrade code found, add product code to list
             [void]$packageinfo.Rows.Add($package.Name,$package.IdentifyingNumber, "")
        }
    }

    $packageinfo | sort Name | Format-table ProductCode, UpgradeCode, Name
}
