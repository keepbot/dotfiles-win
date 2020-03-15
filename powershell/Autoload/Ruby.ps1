# Ruby aliases
if (Get-Command ruby.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:ruby} = { ruby.exe -w @args }
    ${function:rre}  = { ruby.exe exec @args }
}

if (Get-Command gem -ErrorAction SilentlyContinue | Test-Path) {
    ${function:rgi}  = { gem install @args }
    ${function:rbi}  = { gem bundle install @args }
}

if (Get-Command bundle -ErrorAction SilentlyContinue | Test-Path) {
    ${function:rbu}  = { bundle update @args }
    ${function:rbe}  = { bundle exec @args }
}

function Get-Rubies {
    $rubies = @(
        'C:\tools\ruby27\bin'
        'C:\tools\ruby26\bin'
        'C:\tools\ruby25\bin'
        'C:\tools\ruby24\bin'
        'C:\tools\ruby23\bin'
        'C:\tools\ruby22\bin'
        'C:\tools\ruby21\bin'
    )
    return $rubies
}

function Find-Ruby {
    <#
    .SYNOPSIS
        List installed Rubies versions on current PC.
    .DESCRIPTION
        List installed Rubies versions on current PC.
    .EXAMPLE
        Find-Ruby
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        Written by: Dmitriy Ivanov
    #>

    $rubies = Get-Rubies

    Write-Host "List of Ruby interpretators on this PC:"
    foreach($ruby in $rubies) {
        $rubyBin = (Join-Path $ruby "ruby.exe")
        if (Test-Path $rubyBin) {
            Write-Host "- [$($( & $rubyBin --version 2>&1) -replace '\D+(\d.\d.\d+)\D.*','$1')] -> $ruby"
        }
    }
}

function Set-Ruby {
    <#
    .SYNOPSIS
        Set Python version on current PC.
    .DESCRIPTION
        Set Python version on current PC.
    .EXAMPLE
        Set-Py
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        Written by: Dmitriy Ivanov
    #>
    $rubies = Get-Rubies
    $Versions = @()
    foreach($ruby in $rubies) {
        $rubyBin = (Join-Path $ruby "ruby.exe")
        if (Test-Path $rubyBin) {
            $Versions += $ruby
        }
    }
    $ChoosenVersion = Select-From-List $Versions "Ruby Version"
    [Environment]::SetEnvironmentVariable("RUBY_PATH", $ChoosenVersion, "Machine")
    Set-Item -Path Env:RUBY_PATH -Value "$ChoosenVersion"
    # Set-Env
}

function Clear-Ruby {
    [Environment]::SetEnvironmentVariable("RUBY_PATH", $null, "Machine")
    if ($env:RUBY_PATH) {
        Remove-Item Env:RUBY_PATH
    }
    # Set-Env
}
