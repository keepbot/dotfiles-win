<#
.SYNOPSIS
Conda scripts.

.DESCRIPTION
Conda scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


if (Get-Command conda.exe -ErrorAction SilentlyContinue | Test-Path) {
    #region conda initialize
    # !! Contents within this block are managed by 'conda init' !!
    (& "conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
    #endregion

    ${function:cnl}     = { conda env list          @args }
    ${function:cnn}     = { conda create -n         @args }
    ${function:cnr}     = { conda env remove -n     @args }
    ${function:cna}     = { conda activate          @args }
    ${function:cnd}     = { conda deactivate        @args }
    ${function:cni}     = { conda init powershell }
    ${function:cneu}    = { conda update -n @args -c defaults conda  }

    function cupdate {
        conda update -n base -c defaults conda
    }

    function Install-Conda-Cling {
        conda install cling -c QuantStack -c conda-forge
        conda install xeus-cling -c QuantStack -c conda-forge
        conda install notebook -c conda-forge
    }
}
