# Architecture

The project uses AWS in a simple way. The website is static, so it does not need a full web server running all the time.

## Main flow

```text
Visitor
  |
  v
Route 53 DNS
  |
  v
CloudFront CDN
  |
  v
S3 bucket with website files
```

When a user visits the website, Route 53 resolves the domain name. CloudFront serves cached files from the closest edge location when possible. If CloudFront does not have the file cached yet, it gets it from S3.

Route 53 gives the DNS entry for the site. In this version it points to one CloudFront distribution. If the company later creates more endpoints, Route 53 can use latency based routing, but I am not adding that now because it would be extra for a simple static website.

## Why this is suitable

The complaint was about slow reload speed for global users. CloudFront is the main fix for that because it reduces the distance between users and website files.

S3 is a good fit because the website only has static files:

- HTML pages
- CSS file
- JavaScript file
- screenshots or assets if needed

## EC2 usage

EC2 is included in the project, but it is not used as the main website server. For this kind of website, hosting everything on EC2 would mean managing a server for no big reason.

The EC2 instance can be used for:

- testing access to S3
- running AWS CLI commands
- uploading or checking files
- connecting to the team sharing bucket

This still shows VM usage without making the deployment more complicated than needed.

## Governance approach

I would split resources by environment:

```text
development -> testing -> production
```

Each environment can have its own bucket and CloudFront distribution if needed. For a small college project, I would at least use clear names and tags so the resources do not get mixed up.

Example tags:

```text
Project: BingeWatchOnline
Environment: Production
Service: WebsiteHosting
```

Access should be controlled through IAM. A teammate who uploads website files should only get S3 upload permissions, not full admin access.

## Billing approach

To keep billing separate and easy to understand:

- use tags on all resources
- create AWS Budgets alerts
- check Cost Explorer
- stop EC2 when not using it
- avoid keeping unused CloudFront distributions or buckets

If this was used by a real company, separate AWS accounts for dev, test, and prod would be cleaner. For this assignment, tags and clear naming are enough.

## Static content and CDN

The static files are uploaded to S3. CloudFront is placed in front of S3. This means users do not directly depend on one server location. It also reduces load on the origin bucket because CloudFront caches the files.

## Storage for teammates

The team sharing bucket is separate from the website bucket. This keeps website hosting files away from shared notes or reports.

Example:

```text
binge-watch-online-site       -> website files
binge-watch-team-share        -> shared project files
```

The shared bucket should stay private.
