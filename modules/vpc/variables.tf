variable "project" {

}

variable "environment" {

}

variable "vpc_cidr" {
  description = "cidr block for vpc"
}

variable "public_subnets_cidr" {
  type = list(string)
}
