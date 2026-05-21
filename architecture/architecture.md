# Architecture

The website is static, so the main hosting service is S3.

```text
User
  |
  v
Route 53
  |
  v
CloudFront
  |
  v
S3 website bucket
```

Route 53 handles the domain name. CloudFront is used as the CDN layer. S3 stores the website files.

EC2 is separate from the website hosting path:

```text
EC2 VM -> AWS CLI -> S3 buckets
```

I would use EC2 to test S3 access and upload/download files from the team sharing bucket. The website itself should not run from EC2 because it is only static HTML.
