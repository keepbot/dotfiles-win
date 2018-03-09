#--------------------------------------------------------------------------------- 
#The sample scripts are not supported under any Microsoft standard support 
#program or service. The sample scripts are provided AS IS without warranty  
#of any kind. Microsoft further disclaims all implied warranties including,  
#without limitation, any implied warranties of merchantability or of fitness for 
#a particular purpose. The entire risk arising out of the use or performance of  
#the sample scripts and documentation remains with you. In no event shall 
#Microsoft, its authors, or anyone else involved in the creation, production, or 
#delivery of the scripts be liable for any damages whatsoever (including, 
#without limitation, damages for loss of business profits, business interruption, 
#loss of business information, or other pecuniary loss) arising out of the use 
#of or inability to use the sample scripts or documentation, even if Microsoft 
#has been advised of the possibility of such damages 
#--------------------------------------------------------------------------------- 

#requires -Version 2.0

Function Set-ApplicationCompatibility
{
<#
 	.SYNOPSIS
        Set-ApplicationCompatibility is an advanced function which can be used to set application's compatibility settings.
    .DESCRIPTION
        Set-ApplicationCompatibility is an advanced function which can be used to set application's compatibility settings.
    .PARAMETER  CurrentUser
        set the application's compatibility settings on single user
    .PARAMETER  AllUsers
		Set the application's compatibility settings on all users
    .PARAMETER  ApplicationLocation
		Specifies location of appliaction
    .PARAMETER  CompatibilityModes
		Specifies compatibility Modes
    .PARAMETER  DisplaySettings
		Specifies display settings
    .PARAMETER  PrivilegeLevel
		Specifies administrator privilege
    .EXAMPLE
        C:\PS> Set-ApplicationCompatibility -CurrentUser -ApplicationLocation "F:\application.exe" -DisplaySettings "256Colors" -CompatibilityModes Windows7

        Successfully set compatibility modes on 'F:\application.exe'

		This command shows how to set compatibility modes on sepcified application.
#>
    [CmdletBinding(SupportsShouldProcess=$true)]

    Param
    (
        [Parameter(Mandatory = $true, ParameterSetName = "CurrentUser")]
        [Switch]$CurrentUser,

        [Parameter(Mandatory = $true, ParameterSetName = "All Users")]
        [Switch]$AllUsers,

        [Parameter()]
        [String[]]$ApplicationLocation,

        [Parameter()]
        [ValidateSet("Windows95","Windows98","WindowsXPSP2","WindowsXPSP3","Windows7")]
        [String]$CompatibilityModes,

        [Parameter()]
        [ValidateSet("640*480","256Colors","HighDPI")]
        [String[]]$DisplaySettings,

        [Parameter()]
        [Switch]$PrivilegeLevel
    )

    $CompatRules = @{"Windows95" = "WIN95"; "Windows98" = "WIN98"; "WindowsXPSP2" = "WINXPSP2"; "WindowsXPSP3" = "WINXPSP3"; "Windows7"= "WIN7RTM"}
    $DisplayRules = @{"640*480" = "640X480"; "256Colors"="256COLOR";"HighDPI"="HIGHDPIAWARE"}

    #Define a variable named $Rules and set the value as null
    $Rules = $null

    #Check if CompatibilityModes parameter is used by users.
    If($CompatibilityModes)
    {
        If($CompatRules.ContainsKey($CompatibilityModes))
        {
            $Rules += $CompatRules.$CompatibilityModes+" "
        }
    }

    #Check if DisplaySetting parameter is used by users.
    If($DisplaySettings)
    {
        Foreach($DisplaySetting in $DisplaySettings)
        {
            If($DisplayRules.ContainsKey($DisplaySetting))
            {
                $Rules += $DisplayRules.$DisplaySetting+" "
            }
        }
    }

    #Check if DisplaySetting parameter is used by users.
    If($PrivilegeLevel)
    {
        $Rules += "RUNASADMIN"+" "
    }

    If($Rules -eq $null)
    {
        Write-Warning "You don't set any compatibility modes, please set it."
    }
    Else
    {
        Foreach($App in $ApplicationLocation)
        {
            If($CurrentUser)
            {
                If($PSCmdlet.ShouldProcess("",""))
                {
                    #invoke the key function to set the registry key
                    RegistrySetting -UserRole "HKCU:" -ApplicationLocation $App -PCARules "$Rules"
                    Write-Host "Successfully set compatibility modes on '$App'"
                }
            }

            If($AllUsers)
            {
                If($PSCmdlet.ShouldProcess("",""))
                {
                    #invoke the key function to set the registry key
                    RegistrySetting -UserRole "HKLM:" -ApplicationLocation $App -PCARules "$Rules"
                    Write-Host "Successfully set compatibility modes on '$App'"
                }
            }
        }
    }
}

Function Remove-ApplicationCompatibility
{
<#
 	.SYNOPSIS
        Remove-ApplicationCompatibility is an advanced function which can be used to remove application's compatibility settings.
    .DESCRIPTION
        Remove-ApplicationCompatibility is an advanced function which can be used to remove application's compatibility settings.
    .PARAMETER  ApplicationLocation
		Specifies location of appliaction
    .EXAMPLE
        C:\PS> Remove-ApplicationCompatibility -ApplicationLocation "F:\Application.exe"
        
        Successfully removed compatitbility settings on 'F:\Application.exe'

		This command shows how to remove the compatibility settings on specified application.
#>
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        [Parameter(Mandatory=$true)]
        [String[]]$ApplicationLocation
    )

    $RegPath = '\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers'

    Foreach($App in $ApplicationLocation)
    {
        Get-ItemProperty -Path "HKCU:$RegPath" -Name "$App" -ErrorAction SilentlyContinue -ErrorVariable IsExistItemInUser | Out-Null
        Get-ItemProperty -Path "HKLM:$RegPath" -Name "$App" -ErrorAction SilentlyContinue -ErrorVariable IsExistItemInMachine | Out-Null

        #Check if item property is exist, if there is no exception message it means item property is exist.
        If($IsExistItemInUser.Exception -eq $null)
        {
            Try
            {
                Write-Verbose "Remove compatibility modes on '$app'"
                Remove-ItemProperty -Path "HKCU:$Regpath" -Name $App | Out-Null
                Write-Host "Successfully removed compatitbility modes on '$App'"
            }
            Catch
            {
                Write-Host "Failed to remove compatibility modes on '$App'"
            }
        }
        ElseIf($IsExistItemInMachine.Exception -eq $null)
        {
            Try
            {
                Write-Verbose "Remove compatibility modes on '$app'"
                Remove-ItemProperty -Path "HKLM:$Regpath" -Name $App | Out-Null
                Write-Host "Successfully removed compatitbility modes on '$App'"
            }
            Catch
            {
                Write-Host "Failed to remove compatibility modes on '$App'"
            }
        }
        Else
        {
            Write-Warning "Cannot find sepcified application '$App' because it does not exist. Please make sure thar the application's location is correct."
        }
    }
}

Function RegistrySetting
{
    Param
    (
        [String]$UserRole,
        [String]$ApplicationLocation,
        [String]$PCARules
    )

    $RegPath = $UserRole + '\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\'
    
    Try
    {
        If(Test-Path "$RegPath\Layers")
        {
            Write-Verbose "Create a new key '$ApplicationLocation' under the $RegPath\Layers path."
            Set-ItemProperty -Path "$RegPath\Layers" -Name "$ApplicationLocation" -Value "$PCARules" -ErrorAction Stop | Out-Null
        }
        Else
        {
            Write-Verbose ""
            New-Item -Path $RegPath -Name "Layers" | Out-Null
            Set-ItemProperty -Path "$RegPath\Layers" -Name "$ApplicationLocation" -Value "$PCARules" -ErrorAction Stop | Out-Null
        }
    }
    Catch
    {
        Write-Host "Failed to set registry."
    }
}


Export-ModuleMember -Function Set-ApplicationCompatibility
Export-ModuleMember -Function Remove-ApplicationCompatibility