param(
  [string]$ConfigPath = ".\deployment\config.json"
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$configFile = Resolve-Path (Join-Path $repoRoot $ConfigPath)
$templateFile = Join-Path $repoRoot "deployment\cloudformation\binge-watch-online.yaml"
$config = Get-Content $configFile | ConvertFrom-Json

$parameters = @(
  "ProjectName=$($config.ProjectName)",
  "EnvironmentName=$($config.EnvironmentName)",
  "WebsiteBucketName=$($config.WebsiteBucketName)",
  "TeamShareBucketName=$($config.TeamShareBucketName)",
  "HostedZoneId=$($config.HostedZoneId)",
  "DomainName=$($config.DomainName)",
  "AcmCertificateArn=$($config.AcmCertificateArn)",
  "CreateEc2=$($config.CreateEc2)",
  "VpcId=$($config.VpcId)",
  "SubnetId=$($config.SubnetId)",
  "KeyName=$($config.KeyName)",
  "AdminCidr=$($config.AdminCidr)"
)

aws cloudformation deploy `
  --stack-name $config.StackName `
  --template-file $templateFile `
  --region $config.Region `
  --capabilities CAPABILITY_NAMED_IAM `
  --parameter-overrides $parameters `
  --tags Project=$($config.ProjectName) Environment=$($config.EnvironmentName)

aws cloudformation describe-stacks `
  --stack-name $config.StackName `
  --region $config.Region `
  --query "Stacks[0].Outputs"
