<#
.SYNOPSIS
Chef scripts.

.DESCRIPTION
Chef scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command kitchen.bat -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:kc}  = { kitchen converge @args }
    ${function:kd}  = { kitchen destroy @args }
    ${function:kl}  = { kitchen list @args }
    ${function:klo} = { kitchen login @args }
    ${function:kt}  = { kitchen test -d never @args }
}

if (Get-Command knife.bat -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:kn}  = { knife node @args }
    ${function:kns} = { knife node show @args }
    ${function:knl} = { knife node list @args }
    ${function:kne} = { knife node edit $($args[0].ToString()) -a }
    ${function:kbl} = { knife block list @args }
    ${function:kbu} = { knife block use @args }
    ${function:ksn} = {
        if ($args.Count -eq 1)
        {
            $recipe_term = ""
        }
        else
        {
            $recipe_term = "AND recipe:*$($args[1].ToString())*"
        }
        knife search node "chef_env*:$($args[0].ToString().ToUpper()) ${recipe_term}" -i
    }
    ${function:ksni} = {
        if ($args.Count -ne 1)
        {
            Write-Host "Usage: ksni <ip_address>"
        }
        else
        {
            knife search node "ipaddress:$($args[0].ToString())" -i
        }
    }

    # Align chef
    ${function:wso2creds} = {
        if ($args.Count -ne 2)
        {
            Write-Host "Usage: wso2creds <environment> <username>"
        }
        else
        {
            kbu itio-vault
            $wso2db = knife vault show wso2creds "$($args[0].ToString().ToUpper())" --mode client --format json | ConvertFrom-Json
            Write-Host $wso2db.users.$($args[1].ToString())
            kbu itio
        }
    }
}
