# Binge Watch Online - AWS Cloud Deployment Project

This project is a simple AWS deployment setup for the Binge Watch Online website. The original website is a static movie registration form, so I kept it as static HTML and focused on how it can be hosted on AWS properly.

The problem is that the website is slow for global users when the files are served from one place. Static files like HTML pages should not depend on only one server location. For this project, S3 stores the website files, CloudFront caches them closer to users, and Route 53 routes the domain name to CloudFront.

EC2 is used only as a support/testing VM. It is not the main website server.

## Project folders

```text
website/
  index.html
  thankyou.html

scripts/
  upload-website.sh
  sync-website.sh
  ec2-s3-test.sh

docs/
  deployment-guide.md
  team-storage.md

architecture/
  architecture.md

screenshots/
```

## AWS services used

- **S3** - stores the static website files
- **CloudFront** - delivers the website through CDN caching
- **Route 53** - handles DNS routing for the website domain
- **EC2** - used for testing and AWS CLI access to S3

## Simple architecture

```text
User -> Route 53 -> CloudFront -> S3 website bucket

EC2 VM -> S3 website bucket
EC2 VM -> S3 team sharing bucket
```

The website files are uploaded to an S3 bucket. CloudFront is connected to that bucket and serves the site from its CDN locations. Route 53 points the domain name to the CloudFront distribution.

The EC2 VM is separate. I would use it to test AWS CLI access, upload a test file, or check that the S3 buckets are reachable.

## Deployment steps

1. Create an S3 bucket for the website files.
2. Upload the files from the `website/` folder.
3. Create a CloudFront distribution and use the S3 bucket as the origin.
4. Set `index.html` as the default root object in CloudFront.
5. Create a Route 53 hosted zone or use an existing one.
6. Add an alias record in Route 53 pointing to the CloudFront distribution.
7. Create a separate S3 bucket for team sharing.
8. Launch a small EC2 instance and configure AWS CLI on it.
9. Test EC2 access to S3 using the commands in `scripts/ec2-s3-test.sh`.

## CLI examples

The scripts are small examples, not a full automation system.

Upload website first time:

```bash
./scripts/upload-website.sh binge-watch-website-bucket
```

Sync later changes:

```bash
./scripts/sync-website.sh binge-watch-website-bucket
```

Test EC2 access to S3:

```bash
./scripts/ec2-s3-test.sh binge-watch-website-bucket binge-watch-team-share-bucket
```

## Team file sharing

For teammates, I would create a separate S3 bucket such as:

```text
binge-watch-team-share
```

This bucket is for shared notes, reports, and project files. It should stay private. Access can be given through IAM users or roles, depending on who needs to upload or download files.

The EC2 instance can use AWS CLI to copy files to and from this bucket.

## Cost and governance

For a small student project, I would keep this simple:

- use clear bucket names for dev/test/prod if needed
- add tags like `Project=BingeWatchOnline`
- keep S3 buckets private unless there is a clear reason
- stop the EC2 instance when not using it
- set a small AWS Budget alert
- check CloudFront and S3 usage if traffic increases

## Notes

This is not meant to be a large company architecture. It is a practical AWS setup for a static website that needs better global loading speed.
