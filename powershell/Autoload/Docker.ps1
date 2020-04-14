<#
.SYNOPSIS
Docker scripts.

.DESCRIPTION
Docker scripts.
#>


# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


# Docker
if (Get-Command docker.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:di} = { docker.exe images }
    ${function:dc} = { docker.exe ps -a }
    ${function:dcl} = { docker.exe rm $(docker ps -aqf status=exited) }
    ${function:dcla} = {
        docker.exe rm $(docker ps -aqf status=exited)
        docker.exe rmi $(docker images -qf dangling=true)
        docker.exe volume rm $(docker volume ls -qf dangling=true)
    }
    ${function:dira} = { docker.exe rmi $(docker images -q) }
    ${function:diraf} = { docker.exe rmi -f $(docker images -q) }

    # Run docker container in interactive mode
    ${function:dri} = { docker.exe run --rm -it @args }
    # Rewrite entry point to shell
    ${function:desh} = { docker.exe run --rm -it --entrypoint /bin/sh @args }

    # inspect docker images
    ${function:dc_trace_cmd} = {
        ${parent}= $(docker.exe inspect -f '{{ .Parent }}' $args[0])
        [int]${level}=$args[1]
        Write-Host ${level}: $(docker inspect -f '{{ .ContainerConfig.Cmd }}' $args[0])
        ${level}=${level}+1
        if (${parent})
        {
            Write-Host ${level}: ${parent}
            dc_trace_cmd ${parent} ${level}
        }
    }
}

if (Get-Command $Env:ProgramFiles\Docker\Docker\DockerCli.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:dokkaSD} = { & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon }
}
