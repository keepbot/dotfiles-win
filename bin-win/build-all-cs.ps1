#requires -version 3
$CSSources          = Join-Path (Get-Item $PSScriptRoot).Parent.FullName "data\csharp"
$CSDestination      = "C:\tools\bin"

Get-ChildItem $CSSources\*.cs | ForEach-Object {
    $OutFileName      = $_.BaseName + ".exe"
    $OutFull          = Join-Path $CSDestination $OutFileName
    csc.exe /t:exe /out:$OutFull $_
}
