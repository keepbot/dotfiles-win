<#
.SYNOPSIS
AWS scripts.

.DESCRIPTION
AWS scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function aws_set_env_vars()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $AccessKey,
        [Parameter(Mandatory=$true)]
        [string] $SecretKey,
        [string] $Region = 'us-east-1'

    )
    $Env:AWS_ACCESS_KEY_ID      = "$AccessKey"
    $Env:AWS_SECRET_ACCESS_KEY  = "$SecretKey"
    $Env:AWS_DEFAULT_REGION     = "$Region"
}


# Get all instances state
function aws_print_all_instances()
{
    $REGIONS=$(aws ec2 describe-regions --region eu-central-1 --output text --query Regions[*].[RegionName])
    foreach ($REGION in $REGIONS)
    {
        Write-Host "Instances in '$REGION'.." -ForegroundColor Green
        # aws ec2 describe-instances --region $REGION | jq '.Reservations[].Instances[] | "EC2: \(.InstanceId): \(.State.Name)"'
        $region_info = $(aws ec2 describe-instances --region $REGION | ConvertFrom-Json)
        foreach ($instance in $region_info.Reservations.Instances)
        {
            Write-Host "$($instance.InstanceId)`t$($instance.State.Name)`t$($instance.InstanceType)" -ForegroundColor Yellow
        }
    }
}

function awless_print_all_instances()
{
    $REGIONS=$(aws ec2 describe-regions --region eu-central-1 --output text --query Regions[*].[RegionName])
    foreach ($REGION in $REGIONS)
    {
        awless list instances -r $REGION
    }
}

# Get all instances public and private IPs
function aws_print_all_ip()
{
    $REGIONS=$(aws ec2 describe-regions --region eu-central-1 --output text --query Regions[*].[RegionName])
    foreach ($REGION in $REGIONS)
    {
        Write-Host "Instances in '$REGION'.." -ForegroundColor Green
        # aws ec2 describe-instances --region $REGION | jq '.Reservations[].Instances[] | "EC2: \(.InstanceId): \(.State.Name)"'
        $region_info = $(aws ec2 describe-instances --region $REGION | ConvertFrom-Json)
        foreach ($instance in $region_info.Reservations.Instances)
        {
            Write-Host "$($instance.InstanceId)`t$($instance.PrivateIpAddress)" -ForegroundColor Yellow -NoNewline
            Write-Host "`t$($instance.PublicIpAddress)" -ForegroundColor Red
        }
    }
}

function aws_set_mfa_session()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $MFADevice,
        [Parameter(Mandatory=$true)]
        [string] $MFAToken,
        [string] $Duration = 3600,
        [string] $Region = 'eu-west-1'
    )
    $creds = ((aws sts get-session-token --serial-number $MFADevice --token-code $MFAToken --duration-seconds $Duration) | ConvertFrom-Json).Credentials

    Set-Item -Path Env:AWS_ACCESS_KEY_ID -Value $creds.AccessKeyId
    Set-Item -Path Env:AWS_SECRET_ACCESS_KEY -Value $creds.SecretAccessKey
    Set-Item -Path Env:AWS_SESSION_TOKEN -Value $creds.SessionToken
    Set-Item -Path Env:AWS_REGION -Value $Region
}

function aws_assume_role()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $RoleARN,
        [Parameter(Mandatory=$true)]
        [string] $SessionName,
        [string] $Region = 'eu-west-1'
    )
    $creds = ((aws sts assume-role --role-arn ${RoleARN} --role-session-name=${SessionName}) | ConvertFrom-Json).Credentials

    Set-Item -Path Env:AWS_ACCESS_KEY_ID -Value $creds.AccessKeyId
    Set-Item -Path Env:AWS_SECRET_ACCESS_KEY -Value $creds.SecretAccessKey
    Set-Item -Path Env:AWS_SESSION_TOKEN -Value $creds.SessionToken
    Set-Item -Path Env:AWS_REGION -Value $Region
}

${function:aws-profiles} = { aws configure list-profiles @args }
