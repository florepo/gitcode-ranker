# gitcode-ranker

<!-- ABOUT THE PROJECT -->
## About the Project

Analyze your github profile's repositories to find out which languages you use in yout projects.

It also determines your most favourite language(s) based on the amount of repositoeries it is used.


[]

<!-- USAGE EXAMPLES -->
## How to use

Enter the profile name you want to analyze.

The application will query the Github API and present the results for the submitted profile name

## Key Features

* Analyse what languages you use in your Github projects and how many projects are build with them.
* Microservice architecture with a React.js frontend hosted on S3 and Rails API backend hosted on AWS Elastic Container Service.
* API backend deployment with AWS Elastic Container Registry and Elastic Container Service an AWS Fargate.
* All required infrastructure for the project are defined and can be provisioned with one command via Terraform.
* CI pipeline allows deployments on push to 'main' branch using Github workflows.

### Built With

* React.js
* [Github API](https://getbootstrap.com/)
* Docker
* [AWS - S3, Cloudfront, ACM, Route53, ELB, ECS, ECR](https://aws.amazon.com/)
* Terraform
* [Github Workflows CI](https://github.com/features/actions)

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.
   ```sh
   git clone https://github.com/github_username/repo_name.git
   ```

### Prerequisites

This is a list of things you need to setup the project.
* [Install](https://learn.hashicorp.com/tutorials/terraform/install-cli) the Terraform CLI

* AWS account and AWS CLI

  - If you don't have an account yet signup for an [free tier AWS account](https://aws.amazon.com/free/) to host the project
  - [Install](https://aws.amazon.com/cli/) and setup the AWS CLI
  - Setup a [Terraform programmatic access user](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) in AWS with the sufficient priviledges to create all resources of the project.
  - Store AWS access credentials for Terraform accces in a [local AWS credentials file](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html). Never store them directly in your codebase!

* Your domain name
  - You will require your own to domain for deploying to AWS.
  - The domain will be needed for TLS certificate validation to enable hosting the website via https:// (which is required for the AR viewer to work, and best practice anyway).
  - Additionally, a subdomain is needed as an endpoint for the backend API.
  - AWS offers to buy a domain with its Route53 service, alternatively you can import your domain from an external source as well (see AWS docs).

### Installation

#### Provision the infrastructure on AWS

First cd into folder /terraform/remote-state-init/ and rename the aws_s3_bucket in the remote-state-s3.tf file to a new unique name (bucket names have to be globally unique).
Import or buy your domain with Route53 and setup a hosted zone with your domain name record.
Adjust root_domain_name and api_sub_domain name in /terraform/enviroment/main.tf to your names.

##### Setup the Terraform remote backend

Run the following command in the same folder to setup the remote state file storage.

  ```
terraform plan
terraform apply
  ```

##### Provision the required AWS resources with terraform

Run the same commands from the /terraform/enviroment folder to setup the resources

 ```
terraform plan
terraform apply
  ```

##### Configure Github Actions

The project uses [Github Actions](https://docs.github.com/en/actions/learn-github-actions) workflows as a CI/CD pipeline for automatic deployment for a push to the main branch.

In order to take advantage of the feature you need to create a programmatic access user for github actions on AWS for this project and store the [AWS access credentials in Github secrects](https://github.com/marketplace/actions/configure-aws-credentials-action-for-github-actions).


<!-- LICENSE -->
## License

Distributed under the MIT License.
