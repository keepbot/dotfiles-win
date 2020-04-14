<#
.SYNOPSIS
Cmake scripts.

.DESCRIPTION
Cmake scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


if (Get-Command cmake.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:cmake2015x86} = { mkdir build; Set-Location build; Set-VC-Vars-All x86; cmake -G "Visual Studio 14 2015" -A Win32 -DCMAKE_BUILD_TYPE="Release" ..; cmake --build . --config "Release" }
    ${function:cmake2015x64} = { mkdir build; Set-Location build; Set-VC-Vars-All x64; cmake -G "Visual Studio 14 2015" -A x64   -DCMAKE_BUILD_TYPE="Release" ..; cmake --build . --config "Release" }
    ${function:cmake2017x86} = { mkdir build; Set-Location build; Set-VC-Vars-All x86; cmake -G "Visual Studio 15 2017" -A Win32 -DCMAKE_BUILD_TYPE="Release" ..; cmake --build . --config "Release" }
    ${function:cmake2017x64} = { mkdir build; Set-Location build; Set-VC-Vars-All x64; cmake -G "Visual Studio 15 2017" -A x64   -DCMAKE_BUILD_TYPE="Release" ..; cmake --build . --config "Release" }
    ${function:cmake2019x86} = { mkdir build; Set-Location build; Set-VC-Vars-All x86; cmake -G "Visual Studio 16 2019" -A Win32 -DCMAKE_BUILD_TYPE="Release" ..; cmake --build . --config "Release" }
    ${function:cmake2019x64} = { mkdir build; Set-Location build; Set-VC-Vars-All x64; cmake -G "Visual Studio 16 2019" -A x64   -DCMAKE_BUILD_TYPE="Release" ..; cmake --build . --config "Release" }
}
