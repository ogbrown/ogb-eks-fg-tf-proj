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

resource "aws_iam_policy" "alb_controller_policy" {
  name        = "${var.short_project_name}-alb-controller-policy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/../iam/policies/aws-load-balancer-controller-policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_controller_policy_attachment" {
  role       = data.aws_iam_role.pod_execution_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}
# Ensure the AWS Load Balancer Controller is installed in the EKS cluster
# This module assumes that the AWS Load Balancer Controller Helm chart is available in the specified repository.
# The chart version should be updated as necessary to match the latest stable release.

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.5.3"

  values = [
    <<EOF
clusterName: ${aws_eks_cluster.fargate.name}
serviceAccount:
  create: false
  name: aws-load-balancer-controller
EOF
  ]

  depends_on = [aws_eks_cluster.fargate]
}

resource "kubernetes_service_account" "alb_controller_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
  }

  automount_service_account_token = true
}

resource "aws_iam_role_policy_attachment" "alb_controller_sa_attachment" {
  role       = data.aws_iam_role.pod_execution_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}

