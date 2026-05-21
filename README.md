# Internship Experience: AWS Global Website Deployment - Binge Watch Online

## Overview

During my internship work, I deployed a static entertainment website for Binge Watch Online using AWS storage, CDN, and DNS services. I kept the website as a static HTML application in `src/` and used EC2 only as a support VM for AWS CLI testing and S3 access checks.

## Architecture

The public traffic path I worked with was:

```text
User -> Route 53 -> CloudFront -> S3 website bucket
```

The operations path was kept separate:

```text
EC2 support VM -> AWS CLI -> S3 website bucket
EC2 support VM -> AWS CLI -> S3 team share bucket
```

Architecture notes are in `architecture/`:

- `architecture.mmd`
- `architecture.svg`
- `architecture.drawio`

## Services Used

- Amazon S3 for static website files and team file sharing
- Amazon CloudFront for CDN caching
- Amazon Route 53 for DNS routing
- Amazon EC2 for support/testing access
- IAM for scoped S3 permissions

## Implementation Steps

1. Created an S3 bucket for the static website files.
2. Uploaded the files from `src/` to the bucket.
3. Created a CloudFront distribution with the S3 bucket as the origin.
4. Set `index.html` as the CloudFront default root object.
5. Configured Route 53 with an alias record pointing to CloudFront.
6. Created a second S3 bucket for team file sharing.
7. Launched a small EC2 instance and attached IAM access for the required S3 buckets.
8. Ran S3 validation from the EC2 instance.

Upload the site:

```bash
./scripts/upload-website.sh binge-watch-online-site
```

Sync updates and optionally invalidate CloudFront:

```bash
./scripts/sync-website.sh binge-watch-online-site E1234567890ABC
```

Test EC2 access to S3:

```bash
./scripts/ec2-s3-test.sh binge-watch-online-site binge-watch-team-share
```

## Troubleshooting Notes

- If the CloudFront URL shows an older page, run the sync script with the distribution ID so it creates an invalidation.
- If `aws s3 ls` fails from EC2, check the IAM role or AWS CLI credentials.
- If the website loads without the thank you page, confirm both `index.html` and `thankyou.html` are in the S3 bucket.
- If Route 53 does not resolve, check the alias target and wait for DNS propagation.

## Key Takeaways

- Static websites do not need EC2 as the public hosting layer.
- CloudFront is useful when static assets are requested from different locations.
- S3 buckets should be separated by purpose: public website origin and private team sharing.
- Small helper scripts make repeat uploads less error-prone.
