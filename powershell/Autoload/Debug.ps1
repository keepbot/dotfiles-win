if (Get-Command gdb.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:gdb_py}   = { gdb.exe -ex r --args python @args }
}
