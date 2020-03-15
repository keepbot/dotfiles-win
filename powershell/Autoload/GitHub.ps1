if (Get-Command git.exe -ErrorAction SilentlyContinue | Test-Path) {
    # FIXME
    ${function:get_gh_user_repos_https} = {
        Write-Host "Clonning source GH repos of $($args[0])"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        for ($i = 1; $i -lt 10; $i++) {
            $repoList = Invoke-WebRequest -Uri "https://api.github.com/users/$($args[0])/repos?sort=pushed&per_page=1000&page=${i}" | ConvertFrom-Json
            foreach($repo in $repoList){
                if(-Not $repo.fork) {
                    git.exe clone $repo.clone_url
                }
            }
        }
    }

    # FIXME
    ${function:get_gh_user_repos_ssh} = {
        Write-Host "Clonning source GH repos of $($args[0])"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        for ($i = 1; $i -lt 10; $i++) {
            $repoList = Invoke-WebRequest -Uri "https://api.github.com/users/$($args[0])/repos?sort=pushed&per_page=100&page=${i}" | ConvertFrom-Json
            foreach($repo in $repoList){
                if(-Not $repo.fork) {
                    git.exe clone $repo.ssh_url
                }
            }
        }
    }

    # FIXME
    ${function:show_gh_user_repos_ssh} = {
        Write-Host "Showing source GH repos of $($args[0])"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        for ($i = 1; $i -lt 10; $i++) {
            $repoList = Invoke-WebRequest -Uri "https://api.github.com/users/$($args[0])/repos?sort=pushed&per_page=100&page=${i}" | ConvertFrom-Json
            foreach($repo in $repoList){
                if(-Not $repo.fork) {
                    Write-Output $repo.ssh_url
                }
            }
        }
    }

    # FIXME
    ${function:get_gh_user_repos_ssh_all} = {
        Write-Host "Clonning all GH repos of $($args[0])"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            for ($i = 1; $i -lt 10; $i++) {
            $repoList = Invoke-WebRequest -Uri "https://api.github.com/users/$($args[0])/repos?sort=pushed&per_page=1000" | ConvertFrom-Json
            foreach($repo in $repoList.ssh_url){
                git.exe clone $repo
            }
        }
    }

    # FIXME
    ${function:show_gh_user_repos_ssh_all} = {
        Write-Host "Showing all GH repos of $($args[0])"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            for ($i = 1; $i -lt 10; $i++) {
            $repoList = Invoke-WebRequest -Uri "https://api.github.com/users/$($args[0])/repos?sort=pushed&per_page=1000" | ConvertFrom-Json
            foreach($repo in $repoList.ssh_url){
                Write-Output $repo
            }
        }
    }

    function Rename-GitHub-Origin {
        param (
            [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
            [string]$NewName
        )
        $dir = Get-Location
        Get-ChildItem $dir -Directory | ForEach-Object {
            Write-Host $_.FullName
            Set-Location $_.FullName
            $oldRemote = git config --get remote.origin.url
            Write-Host "Old remote:"
            git remote -v
            $repo = Split-Path $oldRemote -leaf
            $newRemote = "git@github.com:${NewName}/${repo}"
            git remote rm origin
            git remote add origin ${newRemote}
            Write-Host "New remote:"
            # Write-Host $newRemote
            git remote -v
            Write-Host "------------------------------------------------------------"
        }
        Set-Location $dir
    }
}
