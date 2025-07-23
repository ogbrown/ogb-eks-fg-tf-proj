variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-2"
}

variable "short_project_name" {
  description = "Short name for the project, used in resource names"
  type        = string
}

variable "tags" {
  type = map(string)
}

variable "cluster_identifier_suffix" {
  description = "Suffix for the cluster identifier to ensure uniqueness"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC to use for the Aurora cluster"
  type        = string
}

variable "general_kms_key_alias" {
  description = "Alias of my KMS Key for Encrypt Decrypt operations"
  type        = string
}

variable "eks_cluster_role_name" {
  description = "A aws_iam_role.eks_cluster_role.name"
  type        = string
}
variable "pod_execution_role_name" {
  description = "A aws_iam_role.fargate_pod_execution_role.name"
  type        = string
}

variable "my_access_ip" {
  description = "Your IP address for security group rules"
  type        = string
}