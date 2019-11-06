function Get-JavaList {
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
        Written by: Dmitriy Ivanov
    #>

    $javas = @()
    $((Get-ChildItem 'C:\Program Files\Java\').FullName         | ForEach-Object { $javas += $_ })
    $((Get-ChildItem 'C:\Program Files (x86)\Java\').FullName   | ForEach-Object { $javas += $_ })

    $javasValidated = @()
    foreach($java in $javas) {
        if (Test-Path $java) {
            $javasValidated  += $java
        }
    }

    return $javasValidated
}

function Find-Java {
    <#
    .SYNOPSIS
        List installed Java versions on current PC.
    .DESCRIPTION
        List installed Java versions on current PC.
    .EXAMPLE
        Find-Java
    .INPUTS
        None
    .OUTPUTS
        Java Kits Array
    .NOTES
        Written by: Dmitriy Ivanov
    #>

    Write-Host "List of Java Kits on this PC:"
    $javas = @()
    $((Get-ChildItem 'C:\Program Files\Java\').Name         | ForEach-Object { $javas += "x64 -> $_" })
    $((Get-ChildItem 'C:\Program Files (x86)\Java\').Name   | ForEach-Object { $javas += "x86 -> $_" })
    return $javas
}


function Set-Java {
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
        Written by: Dmitriy Ivanov
    #>
    $ChoosenJavaVersion = Select-From-List $(Get-JavaList) "Java path"
    [Environment]::SetEnvironmentVariable("JAVA_HOME", ${ChoosenJavaVersion}, "Machine")
    $env:JAVA_HOME = ${ChoosenJavaVersion}
    $env:PATH = "${env:JAVA_HOME}\bin;${env:PATH}"
}
