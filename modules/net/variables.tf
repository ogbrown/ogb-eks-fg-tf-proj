variable "tags" {
  type = map(string)
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}
variable "short_project_name" {
  description = "Short name for the project, used in resource names"
  type        = string
  
}
variable "vpc_name" {
  description = "Name of the VPC to use for the Aurora cluster"
  type        = string
}
variable "my_access_ip" {
  description = "Your IP address for security group rules"
  type        = string
  
}

