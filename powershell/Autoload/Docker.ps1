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
if (Get-Command docker -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:di}    = { docker images }
    ${function:dc}    = { docker ps -a }
    ${function:dcle}  = { docker rm $(docker ps -aqf status=exited) }
    ${function:dclc}  = { docker rm $(docker ps -aqf status=created) }
    ${function:dcli}  = { docker rmi $(docker images -q) }
    ${function:dclif} = { docker rmi -f $(docker images -q) }
    ${function:dcla}  = {
        docker rm $(docker ps -aqf status=exited)
        docker rmi $(docker images -qf dangling=true)
        docker volume rm $(docker volume ls -qf dangling=true)
    }

    ${function:dsprune}  = { docker system prune }

    # Run docker container in interactive mode
    ${function:dri}  = { docker run --rm -it @args }
    # Rewrite entry point to shell
    ${function:desh} = { docker run --rm -it --entrypoint /bin/sh @args }

    # inspect docker images
    ${function:dc_trace_cmd} = {
        ${parent}= $(docker inspect -f '{{ .Parent }}' $args[0])
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
