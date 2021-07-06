<#
.SYNOPSIS
Terraform scripts.

.DESCRIPTION
Terraform scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command terraform.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:terrafrom}   = { terraform.exe @args }
    ${function:t}           = { terraform.exe @args }
    ${function:ta}          = { terraform.exe apply terraform.plan @args }
    ${function:ti}          = { terraform.exe init @args }
    ${function:tp}          = { terraform.exe plan -out terraform.plan @args}
    ${function:tpd}         = { terraform.exe plan -destroy -out terraform.plan @args}
    ${function:tpdm}        = { terraform.exe plan -destroy -target module.${args} -out terraform.plan }
    # ${function:tp}          = { if ($args[0] -And -Not $args[1]) {terraform.exe plan -out terraform.plan --var-file=$args.tfvars} else {terraform.exe plan -out terraform.plan @args}}
    # ${function:tpd}         = { if ($args[0] -And -Not $args[1]) {terraform.exe plan -destroy -out terraform.plan --var-file=$args.tfvars} else {terraform.exe plan -destroy -out terraform.plan @args}}
    ${function:tw}          = { terraform.exe workspace @args }
    ${function:twd}         = { terraform.exe workspace delete @args }
    ${function:twn}         = { terraform.exe workspace new @args }
    ${function:twl}         = { terraform.exe workspace list @args }
    ${function:tws}         = { terraform.exe workspace select @args }
}

${function:packer_verbose_logs_on}  = { $Env:PACKER_LOG=1 }
${function:packer_verbose_logs_off} = { $Env:PACKER_LOG=0 }

