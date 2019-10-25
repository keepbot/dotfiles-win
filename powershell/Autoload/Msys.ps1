function Use-Msys2 {
    $msys_path = $(Get-Command msys2.exe -ErrorAction SilentlyContinue | Split-Path)

    if ($msys_path) {
        $msys_bin_path = $(Join-Path $msys_path "usr\bin")
        Set-Item -Path Env:PATH -Value "$msys_bin_path;$Env:PATH"
    } else {
        Write-Host "ERROR: MSYS2 not found. Exiting..." -ForegroundColor Red
        return
    }
}
