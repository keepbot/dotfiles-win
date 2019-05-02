if (Get-Command conda.exe -ErrorAction SilentlyContinue | Test-Path) {
    #region conda initialize
    # !! Contents within this block are managed by 'conda init' !!
    (& "conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
    #endregion

    ${function:cnl}      = { conda-env list }
    ${function:cnn}      = { conda create -n @args }
    ${function:cna}      = { conda activate @args }
    ${function:cni}      = { conda init powershell }

    function cupdate {
        conda update -n base -c defaults conda
    }

    function Install-Conda-Cling {
        conda install cling -c QuantStack -c conda-forge
        conda install xeus-cling -c QuantStack -c conda-forge
        conda install notebook -c conda-forge
    }
}
