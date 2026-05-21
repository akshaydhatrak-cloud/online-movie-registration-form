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

Route 53 handled the domain name, CloudFront worked as the CDN layer, and S3 stored the website files.

EC2 is separate from the website hosting path:

```text
EC2 VM -> AWS CLI -> S3 buckets
```

EC2 was used to test S3 access and upload/download files from the team sharing bucket. The website itself did not run from EC2 because it was only static HTML.
