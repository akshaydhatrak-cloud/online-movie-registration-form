param(
  [Parameter(Mandatory = $true)][string]$StackName,
  [Parameter(Mandatory = $true)][ValidateSet("dev", "test", "prod")][string]$EnvironmentName,
  [Parameter(Mandatory = $true)][string]$VpcId,
  [Parameter(Mandatory = $true)][string]$SubnetIds,
  [string]$ProjectName = "binge-watch-online",
  [string]$DomainName = "",
  [string]$HostedZoneId = "",
  [string]$Region = "us-east-1"
)

aws cloudformation deploy `
  --region $Region `
  --stack-name $StackName `
  --template-file "../cloudformation/global-website.yml" `
  --parameter-overrides `
    ProjectName=$ProjectName `
    EnvironmentName=$EnvironmentName `
    VpcId=$VpcId `
    SubnetIds=$SubnetIds `
    DomainName=$DomainName `
    HostedZoneId=$HostedZoneId

aws cloudformation describe-stacks `
  --region $Region `
  --stack-name $StackName `
  --query "Stacks[0].Outputs"
