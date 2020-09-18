
function set_sonar_token
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Token
    )
    Set-Item -Path Env:SONAR_TOKEN -Value $Token
}
