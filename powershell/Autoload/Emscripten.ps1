if (Get-Command emsdk -ErrorAction SilentlyContinue | Test-Path) {
    ${function:ema} = { if ($args) {emsdk activate @args} else {emsdk activate latest}}
    ${function:emi} = { if ($args) {emsdk install  @args} else {emsdk install  latest}}
    ${function:eml} = { emsdk list }
    ${function:emup} = { emsdk update }
    ${function:emun} = { emsdk uninstall @args }
}
