function Get-JBList {
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

    $ideas = @()
    $((Get-ChildItem "${env:USERPROFILE}\AppData\Local\JetBrains\Toolbox\apps\AndroidStudio\ch-0\" -Directory).FullName | ForEach-Object { $ideas += $_ })
    $((Get-ChildItem "${env:USERPROFILE}\AppData\Local\JetBrains\Toolbox\apps\IDEA-U\ch-0\" -Directory).FullName        | ForEach-Object { $ideas += $_ })
    $((Get-ChildItem "${env:USERPROFILE}\AppData\Local\JetBrains\Toolbox\apps\IDEA-C\ch-0\" -Directory).FullName        | ForEach-Object { $ideas += $_ })
    return $ideas
}

# Get-ChildItem "${env:USERPROFILE}\AppData\Local\JetBrains\Toolbox\apps\IDEA-U\ch-0\" -Directory
# C:\Users\Admin\AppData\Local\JetBrains\Toolbox\apps\IDEA-U\ch-0\192.7142.36\bin
