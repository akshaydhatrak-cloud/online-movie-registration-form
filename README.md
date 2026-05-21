# Binge Watch Online - AWS Cloud Deployment Project

This repository contains a small static website for **Binge Watch Online**, an online entertainment provider. The main aim of this project is not to redesign the website, but to deploy it properly on AWS so users from different regions can load the pages faster.

The website files are kept simple because the cloud setup is the main part of the assignment.

## Problem Statement

Binge Watch Online has a website that is getting traffic from different parts of the world. At first the static pages and files were being served from one place, so users far away from the server were facing slow page reloads.

To improve this, the static website content is uploaded to Amazon S3 and delivered through Amazon CloudFront. Route 53 is used for DNS routing so users can access the site using a proper domain name. EC2 is included as the virtual machine service for admin/testing work and for connecting with storage.

## AWS Services Used

- **Amazon S3** - stores the static website files like HTML, CSS, JS, and shared files
- **Amazon CloudFront** - CDN used to cache website files closer to users
- **Amazon Route 53** - manages DNS and points the domain to CloudFront
- **Amazon EC2** - used as a Linux or Windows VM for testing/admin work and connecting to S3

## Project Structure

```text
online-movie-registration-form/
|-- architecture/
|   `-- simple-architecture.md
|-- deployment/
|   `-- aws-cli-notes.md
|-- docs/
|   |-- architecture.md
|   `-- deployment-guide.md
|-- screenshots/
|   |-- registration-form.png
|   `-- thank-you-page.png
|-- website/
|   |-- index.html
|   |-- script.js
|   |-- styles.css
|   `-- thankyou.html
`-- README.md
```

## Basic Architecture

The user opens the website domain in their browser. Route 53 handles the DNS request and sends the user to the CloudFront distribution. CloudFront checks if it already has the static files cached at an edge location. If not, it gets the files from the S3 bucket.

The rough flow is:

```text
User -> Route 53 -> CloudFront -> S3 bucket -> Website files
```

EC2 is not hosting the static website in this design. I am using it more like a support VM, for example to test access, run AWS CLI commands, or connect with S3 for shared storage work.

For DNS-level routing, Route 53 will use an alias record for the CloudFront distribution. If the company later adds more endpoints, Route 53 latency based routing can be added, but for this project one CloudFront distribution is enough.

## Deployment Steps

1. Create an S3 bucket for the website files.
2. Upload everything inside the `website/` folder to the bucket.
3. Create a CloudFront distribution and set the S3 bucket as the origin.
4. Configure the default root object as `index.html`.
5. Use Route 53 to point the domain name to the CloudFront distribution.
6. Launch an EC2 instance for testing and admin tasks.
7. Install AWS CLI on the EC2 instance and test access to the S3 bucket.

More detailed steps are written in [docs/deployment-guide.md](docs/deployment-guide.md).

## CDN Explanation

CloudFront helps because it keeps copies of the static files in edge locations. If someone opens the website from another country, the content does not always need to come from the original S3 location. This should reduce load time for pages, images, CSS, and JavaScript.

For this project the CDN is useful because the website is mostly static and does not need a backend server for every request.

## Governance Ideas

For development, testing, and production, I would keep separate S3 buckets and clear naming. Example:

- `binge-watch-dev-site`
- `binge-watch-test-site`
- `binge-watch-prod-site`

I would also use IAM users or roles with only the access they need. For example, a teammate uploading files should not be able to delete billing settings or change Route 53 records.

Tags can be added to resources so it is easier to track them later:

- `Project = BingeWatchOnline`
- `Environment = Dev/Test/Prod`
- `Owner = CloudStudent`

## Billing and Cost Management

AWS Budgets can be used to set a monthly alert, like warning me if the project goes above a small test budget. Cost Explorer can show which service is costing more.

For this project, the main costs may come from CloudFront data transfer, S3 storage/requests, Route 53 hosted zone charges, and EC2 running time. I would stop the EC2 instance when I am not using it.

## Shared Storage for Teammates

A separate S3 bucket or folder can be used for team files. Teammates can upload screenshots, notes, and deployment files there. Access should be controlled using IAM policies instead of making everything public.

The EC2 VM can connect to S3 using AWS CLI:

```bash
aws s3 ls
aws s3 cp ./notes.txt s3://binge-watch-team-share/
```

## Screenshots

Registration page:

![Binge Watch Online registration form](screenshots/registration-form.png)

Confirmation page:

![Binge Watch Online confirmation page](screenshots/thank-you-page.png)

## Future Improvements

- Add a custom domain with HTTPS using AWS Certificate Manager
- Add CloudFront invalidation steps after updating files
- Keep a simple version history of uploaded website files
- Add better error pages like `404.html`
- Use separate AWS accounts if the project becomes bigger

## Conclusion

This project shows a practical way to deploy a small entertainment website on AWS. S3 stores the static files, CloudFront improves loading speed globally, Route 53 handles DNS, and EC2 is used for testing and storage access tasks. It is a simple setup, but it matches the problem better than running the whole static website from only one server.
