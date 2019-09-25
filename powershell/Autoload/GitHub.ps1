if (Get-Command git.exe -ErrorAction SilentlyContinue | Test-Path) {
    ${function:get_gh_user_repos_https} = {
        Write-Host "Clonning all GH repos of $($args[0])"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $repoList = Invoke-WebRequest -Uri "https://api.github.com/users/$($args[0])/repos?per_page=1000" | ConvertFrom-Json
        foreach($repo in $repoList.clone_url){
            git.exe clone $repo
        }
    }

    ${function:get_gh_user_repos_ssh} = {
        Write-Host "Clonning all GH repos of $($args[0])"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $repoList = Invoke-WebRequest -Uri "https://api.github.com/users/$($args[0])/repos?per_page=1000" | ConvertFrom-Json
        foreach($repo in $repoList.ssh_url){
            git.exe clone $repo
        }
    }
}
