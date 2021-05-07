<#
.SYNOPSIS
Ruby scripts.

.DESCRIPTION
Ruby scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# Ruby aliases
if (Get-Command ruby.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:ruby} = { ruby.exe -w @args }
    ${function:rre}  = { ruby.exe exec @args }
}

if (Get-Command gem -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:rgi}  = { gem install @args }
    ${function:rbi}  = { gem bundle install @args }
}

if (Get-Command bundle -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:rbu}  = { bundle update @args }
    ${function:rbe}  = { bundle exec @args }
}

function Get-Rubies
{
    $rubies = @(
        'C:\tools\ruby30\bin'
        'C:\tools\ruby29\bin'
        'C:\tools\ruby28\bin'
        'C:\tools\ruby27\bin'
        'C:\tools\ruby26\bin'
        'C:\tools\ruby25\bin'
        'C:\tools\ruby24\bin'
        'C:\tools\ruby23\bin'
        'C:\tools\ruby22\bin'
        'C:\tools\ruby21\bin'
        'C:\tools\jruby92\bin'
        'C:\tools\jruby91\bin'
        'C:\tools\jruby90\bin'
    )
    return $rubies
}

function Find-Ruby
{
    $rubies = Get-Rubies

    Write-Host "List of Ruby interpretators on this PC:"
    foreach ($ruby in $rubies)
    {
        if ($ruby -match "jruby")
        {
            $rubyBin = (Join-Path $ruby "jruby.exe")
        }
        else
        {
            $rubyBin = (Join-Path $ruby "ruby.exe")
        }

        if (Test-Path $rubyBin)
        {
            Write-Host "- [$($( & $rubyBin --version 2>&1) -replace '\D+(\d.\d.\d+)\D.*','$1')] -> $ruby"
        }
    }
}

function Set-Ruby
{
    $rubies = Get-Rubies
    $ValidatedRubies = @()
    $Versions = @()
    foreach ($ruby in $rubies)
    {
        if ($ruby -match "jruby")
        {
            $rubyBin = (Join-Path $ruby "jruby.exe")
        }
        else
        {
            $rubyBin = (Join-Path $ruby "ruby.exe")
        }

        if (Test-Path $rubyBin)
        {
            $ValidatedRubies += $ruby
            $Versions += "$($( & $rubyBin --version 2>&1) -replace '\D+(\d.\d.\d+)\D.*','$1')"
        }
    }
    $ChoosenVersion = Select-From-List $ValidatedRubies "Ruby Version" $Versions
    [Environment]::SetEnvironmentVariable("RUBY_PATH", $ChoosenVersion, "Machine")
    Set-Item -Path Env:RUBY_PATH -Value "$ChoosenVersion"
    # Set-Env
}

function Clear-Ruby
{
    [Environment]::SetEnvironmentVariable("RUBY_PATH", $null, "Machine")
    if ($env:RUBY_PATH)
    {
        Remove-Item Env:RUBY_PATH
    }
    # Set-Env
}
