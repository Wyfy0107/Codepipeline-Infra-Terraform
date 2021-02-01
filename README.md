# Codepipeline Infrastructure for CI/CD

This configuration uses Terraform to create resources on AWS and automate a CI/CD pipeline with source code coming from Github. The code will go through AWS Codepipeline and deployed onto an Autoscaling group of EC2. This can scale your instances automatically based on cpu usage

## Prerequisites

These should be completed:

- Create a github Oauth token to allow AWS to get your source code
- Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Create your IAM credentials in AWS console. It should have the following policies:
  - S3 full access
  - EC2 full access
  - IAM full access
  - CodeDeploy full access
  - CodeBuild admin access
  - CodePipeline full access

## Instructions

1. Clone/Fork this repository
2. Run `terraform init`
3. Create `terraform.auto.tfvars` file and declare all required variables
4. Run `terraform plan`
5. If the above output is ok, then run `terraform apply`

The **app** folder is a reference for the code to be deployed.

After all resources are created, the pipeline should take your source code from github and start the process. You can observe the pipeline inside AWS CodePipeline console.

There are some predefined scripts inside **scripts** directory:

- To ssh into your created instance, run the `ssh.sh`
- To test your load balancer, run the `test-lb.sh`
- `codedeploy-agent.sh` is used to set up the EC2 instance and is used by the launch configuration
