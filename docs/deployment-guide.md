# Deployment Guide

This guide is for deploying the Binge Watch Online static website using S3, CloudFront, Route 53, and EC2.

I wrote the steps in the same order I would follow in the AWS console.

## 1. Prepare the website files

The files that need to be uploaded are inside the `website/` folder:

```text
index.html
styles.css
script.js
thankyou.html
```

Before uploading, open `website/index.html` locally and check that the page loads correctly.

## 2. Create the S3 bucket

Create an S3 bucket for the static website files. A name could be:

```text
binge-watch-online-site
```

For a real domain, the bucket name does not have to match the domain if CloudFront is used. I would keep the bucket private and let CloudFront access it.

Upload all files from the `website/` folder to this bucket.

## 3. Create CloudFront distribution

Create a CloudFront distribution with the S3 bucket as the origin.

Important settings:

- Origin: the S3 bucket
- Viewer protocol policy: redirect HTTP to HTTPS
- Default root object: `index.html`
- Allowed methods: GET and HEAD is enough for this static site
- Cache policy: use the managed caching policy for static content

After CloudFront is created, AWS gives a domain name like:

```text
dxxxxxxxxxxxxx.cloudfront.net
```

Open this URL and check if the website loads.

## 4. Update files later

When website files are changed, upload the changed files again to S3.

If CloudFront is still showing the old page, create an invalidation:

```text
/*
```

For a small project this is fine. For a bigger website, I would invalidate only changed files.

## 5. Configure Route 53

Create a hosted zone in Route 53 for the domain name.

Then create an alias record:

- Record type: A
- Alias: Yes
- Target: CloudFront distribution

This means users can visit the website using the normal domain instead of the CloudFront URL.

For this project, Route 53 is mainly used to route the domain to CloudFront. If there are multiple website endpoints later, latency based routing can be used to send users to the better endpoint based on location.

## 6. Launch EC2 VM

Launch a small EC2 instance for testing and admin work.

For example:

- Amazon Linux 2023 or Windows Server
- Small instance type for lab work
- Security group with SSH or RDP only from my IP

The EC2 instance is not needed to serve the static pages because S3 and CloudFront are doing that job.

## 7. Connect EC2 with S3

Attach an IAM role to the EC2 instance. The role should allow only the required S3 actions.

Example tasks from EC2:

```bash
aws s3 ls
aws s3 ls s3://binge-watch-online-site/
aws s3 cp test-file.txt s3://binge-watch-team-share/
```

This proves the VM can connect with the storage service.

## 8. Team sharing bucket

Create another S3 bucket for teammate files, for example:

```text
binge-watch-team-share
```

This bucket can store shared screenshots, notes, reports, or deployment files. It should not be public. Teammates can get access through IAM users, IAM Identity Center, or pre-signed URLs if the file only needs to be shared for a short time.

## 9. Quick testing checklist

- S3 bucket contains the website files
- CloudFront URL opens `index.html`
- CSS and JavaScript load correctly
- `thankyou.html` opens after form submit
- Route 53 domain points to CloudFront
- EC2 can run `aws s3 ls`
- Billing budget alert is enabled

## Notes

For this assignment, I am keeping the deployment simple. I am not using Kubernetes, Terraform, or a CI/CD pipeline because the site is only static and the requirement is mainly about AWS hosting and CDN delivery.
