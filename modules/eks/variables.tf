variable "tags" {
  type = map(string)
}

variable "short_project_name" {
  description = "Short name for the project, used in resource names"
  type        = string
}

variable "eks_security_group_id" {
  description = "Security group ID for the EKS cluster"
  type        = string
}
variable "eks_subnet_ids" {
  description = "Subnet ID for the EKS cluster"
  type        = list(string)
}
variable "cluster_identifier_suffix" {
  description = "Suffix for the cluster identifier to ensure uniqueness"
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
