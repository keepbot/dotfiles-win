#!/usr/bin/env powershell
# Set-ExecutionPolicy RemoteSigned -scope CurrentUser

$profileDir         = Split-Path -Parent $profile
$dotfilesProfileDir = Join-Path $PSScriptRoot "powershell"

"DEVELOPMENT" | Out-File ( Join-Path $PSScriptRoot "bash/var.env"    )
"COMPLEX"     | Out-File ( Join-Path $PSScriptRoot "bash/var.prompt" )

If (-Not (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe")) {
  Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Making Symlinks
# Remove-Item -Force -Confirm:$false -Recurse $profileDir
If (Test-Path $profileDir                      )  {[System.IO.Directory]::Delete(                $profileDir              , $true)}
If (Test-Path (Join-Path $HOME ".bash"        ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME ".bash" ), $true)}
If (Test-Path (Join-Path $HOME ".bin"         ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME ".bin"  ), $true)}
If (Test-Path (Join-Path $HOME ".tmux"        ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME ".tmux" ), $true)}
If (Test-Path (Join-Path $HOME ".vim"         ))  {[System.IO.Directory]::Delete(              ( Join-Path $HOME ".vim"  ), $true)}
If (Test-Path "c:\cmder\"                      )  {[System.IO.Directory]::Delete(                "c:\cmder\"              , $true)}

If (Test-Path (Join-Path $HOME ".bash_profile"))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".bash_profile" )}
If (Test-Path (Join-Path $HOME ".bashrc"      ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".bashrc"       )}
If (Test-Path (Join-Path $HOME ".gemrc"       ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".gemrc"        )}
If (Test-Path (Join-Path $HOME ".gitconfig"   ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".gitconfig"    )}
If (Test-Path (Join-Path $HOME ".gitmessage"  ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".gitmessage"   )}
If (Test-Path (Join-Path $HOME ".profile"     ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".profile"      )}
If (Test-Path (Join-Path $HOME ".tmux.conf"   ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".tmux.conf"    )}
If (Test-Path (Join-Path $HOME ".vimrc"       ))  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path $HOME ".vimrc"        )}

If (Test-Path "C:\sr\config.yaml"              )  {Remove-Item -Force -Confirm:$false -Recurse ( Join-Path "C:\sr" "config.yaml"           )}

C:\Windows\System32\cmd.exe /c mklink /d $profileDir $dotfilesProfileDir
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $HOME ".bash"         ) ( Join-Path $PSScriptRoot "bash"              )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $HOME ".bin"          ) ( Join-Path $PSScriptRoot "bin-win"           )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $HOME ".tmux"         ) ( Join-Path $PSScriptRoot "tmux"              )
C:\Windows\System32\cmd.exe /c mklink /d ( Join-Path $HOME ".vim"          ) ( Join-Path $PSScriptRoot "vim"               )
C:\Windows\System32\cmd.exe /c mklink /d   "c:\cmder\"                       ( Join-Path $HOME          ".bin\cmder"       )

C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".bash_profile" ) ( Join-Path $PSScriptRoot "bash_profile"      )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".profile"      ) ( Join-Path $PSScriptRoot "bash_profile"      )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".bashrc"       ) ( Join-Path $PSScriptRoot "bashrc"            )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".gemrc"        ) ( Join-Path $PSScriptRoot "gemrc"             )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".gitconfig"    ) ( Join-Path $PSScriptRoot ".gitconfig"        )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".gitmessage"   ) ( Join-Path $PSScriptRoot ".gitmessage"       )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".tmux.conf"    ) ( Join-Path $PSScriptRoot "tmux.conf"         )
C:\Windows\System32\cmd.exe /c mklink    ( Join-Path $HOME ".vimrc"        ) ( Join-Path $PSScriptRoot "vimrc-win"         )

C:\Windows\System32\cmd.exe /c mklink      "C:\sr\config.yaml"               ( Join-Path $PSScriptRoot "stack\config.yaml" )

$list_of_modules = @(
  "OData"
  "posh-docker"
  "posh-git"
  "PSReadline"
)
Write-Host ""
Write-Host "Initialization of PowerShell profile. Be patient. It's hurt only first time..."
Write-Host ""

foreach ($module in $list_of_modules) {
  if (Get-Module -ListAvailable -Name $module ) {
    Write-Host "Module $module already exist"
    #Update-Module $module
  } else {
    Install-Module -Scope CurrentUser $module
    Write-Host "Module $module succesfully installed"
  }

  Import-Module $module
}


# Cleanup
#Remove-Variable $profileDir
#Remove-Variable $dotfilesProfileDir

#Write-Host "mklink $profileDir ./powershell"
#cmd /c mklink c:\path\to\symlink c:\target\file
# if (!(Verify-Elevated)) {
#   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
#   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
#   $newProcess.Verb = "runas";
#   [System.Diagnostics.Process]::Start($newProcess);
#   exit
# }




