param(
  [Parameter(Mandatory = $true)][string]$BucketName,
  [string]$Region = "us-east-1"
)

aws s3 sync "../src" "s3://$BucketName" `
  --region $Region `
  --delete `
  --exclude "*.ps1"
