data "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name
}
data "aws_iam_role" "pod_execution_role" {
  name = var.pod_execution_role_name
}

resource "aws_eks_cluster" "fargate" {
  name     = "${var.short_project_name}-${var.cluster_identifier_suffix}"
  role_arn = data.aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.eks_subnet_ids
    security_group_ids     = [var.eks_security_group_id]
    endpoint_public_access = true # Enable public access
    endpoint_private_access = true # Disable private access to reduce costs
  }
  # No node group; Fargate only
}

resource "aws_eks_fargate_profile" "default" {
  cluster_name           = aws_eks_cluster.fargate.name
  fargate_profile_name   = "default"
  pod_execution_role_arn = data.aws_iam_role.pod_execution_role.arn
  subnet_ids             = var.eks_subnet_ids

  selector {
    namespace = "default"
  }
  tags = var.tags
}