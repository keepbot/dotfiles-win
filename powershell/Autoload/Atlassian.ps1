function Get-Bamboo-AMI {
    if ($args.Count -ne 2) {
        Write-Host "Usage: Bamboo-Get-AMI <Bamboo_version> <filter(windows, linux, PV, HVM)>"
    }
    else {
        ${BAMBOO_VERSION}=$args[0]
        Write-Host "For Bamboo version: ${BAMBOO_VERSION}"
        [xml]${pom_file} = (New-Object System.Net.WebClient).DownloadString("https://maven.atlassian.com/content/groups/public/com/atlassian/bamboo/atlassian-bamboo/${BAMBOO_VERSION}/atlassian-bamboo-${BAMBOO_VERSION}.pom")
        ${ELASTIC_VERSION}=${pom_file}.project.properties.'elastic-image.version'
        Write-Host "Elastic bamboo version is $ELASTIC_VERSION"
        ${amis} = Invoke-RestMethod https://maven.atlassian.com/content/groups/public/com/atlassian/bamboo/atlassian-bamboo-elastic-image/${ELASTIC_VERSION}/atlassian-bamboo-elastic-image-${ELASTIC_VERSION}.ami
        ${amis}.tostring() -split "[`r`n]" | Select-String "image." | Select-String $args[1] | Sort-Object
        Write-Host "REMEMBER: Use the Image from the appropriate region!"
    }
}

function Get-AtlassianCIDRs {
    $Responce = (Invoke-Webrequest https://ip-ranges.atlassian.com/).Content
    return ($Responce | ConvertFrom-Json).items.cidr
}
