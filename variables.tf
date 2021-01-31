variable "aws_region" {
  default = "us-west-1"
}

variable "aws_access_key" {

}

variable "aws_secret_key" {

}

variable "project" {

}

variable "environment" {

}

variable "github_oauth_token" {

}

variable "repo_owner" {

}

variable "repo_name" {

}

variable "branch" {
  default = "master"
}

variable "poll_source_changes" {
  default = true
}

variable "vpc_cidr" {
  description = "cidr block for vpc"
}

variable "public_subnets_cidr" {
  type = list(string)
}

