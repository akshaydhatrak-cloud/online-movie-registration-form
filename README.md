# AWS Global Website Deployment (Binge Watch Online)

## Business Objective

Binge Watch Online needs a static website deployment that can serve global users with better page load performance. The site is a small HTML registration flow, so the hosting model keeps the application static and moves delivery closer to users through CDN caching.

## Cloud Architecture Overview

The website files in `src/` are uploaded to Amazon S3. Amazon CloudFront uses the S3 bucket as its origin and caches the pages at edge locations. Route 53 routes the public domain to the CloudFront distribution.

EC2 is not used to host the website. It is used as a support VM for AWS CLI checks, S3 upload/download validation, and operational testing. IAM controls access to the website bucket and the team sharing bucket.

```text
User -> Route 53 -> CloudFront -> S3 website bucket

EC2 support VM -> AWS CLI -> S3 buckets
```

The draw.io source is available at `docs/architecture.drawio`.

## Services Used

- Amazon S3
- Amazon CloudFront
- Amazon Route 53
- Amazon EC2
- AWS IAM
- Amazon VPC for the EC2 support VM network

## Deployment Workflow

1. Create a private S3 bucket for the static website files.
2. Upload the contents of `src/` to the website bucket.
3. Create a CloudFront distribution with the S3 bucket as the origin.
4. Set `index.html` as the CloudFront default root object.
5. Configure Route 53 with an alias record pointing the domain to CloudFront.
6. Create a separate S3 bucket for team file sharing.
7. Launch a small EC2 instance in a VPC subnet for testing and AWS CLI access.
8. Validate S3 access from EC2 using the scripts in `infrastructure/scripts/`.

Example upload command:

```bash
./infrastructure/scripts/upload-website.sh binge-watch-online-site
```

Example sync with CloudFront invalidation:

```bash
./infrastructure/scripts/sync-website.sh binge-watch-online-site E1234567890ABC
```

## Security Considerations

- Keep the S3 website bucket private and expose content through CloudFront.
- Use IAM roles or scoped IAM users for S3 access.
- Restrict EC2 SSH access to an approved admin IP range.
- Keep the team sharing bucket separate from the public website bucket.
- Avoid using EC2 as the public web server for this static workload.

## Performance and Scalability Improvements

CloudFront reduces repeated origin requests and improves loading for users outside the S3 bucket region. Static assets are cacheable, so the setup scales better than serving all users from a single VM.

Route 53 provides DNS routing to the CloudFront distribution. If the website grows later, DNS and CloudFront settings can be adjusted without changing the source HTML.

## Operational Insights

- Use CloudFront invalidations when updated pages need to appear immediately.
- Review S3 and CloudFront usage for unexpected traffic spikes.
- Stop the EC2 support VM when it is not needed.
- Apply resource tags such as `Project=BingeWatchOnline` and `Environment=ProductionLike`.
