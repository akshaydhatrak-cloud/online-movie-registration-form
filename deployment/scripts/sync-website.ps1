param(
  [string]$ConfigPath = ".\deployment\config.json",
  [switch]$Invalidate
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$configFile = Resolve-Path (Join-Path $repoRoot $ConfigPath)
$websitePath = Join-Path $repoRoot "website"
$config = Get-Content $configFile | ConvertFrom-Json

aws s3 sync $websitePath "s3://$($config.WebsiteBucketName)" `
  --region $config.Region `
  --delete

if ($Invalidate) {
  $distributionId = aws cloudformation describe-stacks `
    --stack-name $config.StackName `
    --region $config.Region `
    --query "Stacks[0].Outputs[?OutputKey=='CloudFrontDistributionId'].OutputValue" `
    --output text

  aws cloudfront create-invalidation `
    --distribution-id $distributionId `
    --paths "/*"
}
