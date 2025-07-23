locals {
  global_tags = merge(
    var.tags,
    {
      LastApplied = timestamp()
    }
  )
}
provider "aws" {
  region = var.aws_region
}
data "aws_caller_identity" "current" {}

data "aws_kms_key" "aurora_kms_key" {
  key_id = "alias/${var.general_kms_key_alias}" # Replace with your KMS key alias
}

module "net" {
  source = "../../modules/net"
  # pass networking vars
  aws_region         = var.aws_region
  short_project_name = var.short_project_name
  tags               = local.global_tags
  vpc_name           = var.vpc_name
  my_access_ip       = var.my_access_ip
}

module "eks" {
  source                    = "../../modules/eks"
  short_project_name        = var.short_project_name
  cluster_identifier_suffix = var.cluster_identifier_suffix
  eks_subnet_ids            = module.net.eks_subnet_ids
  eks_security_group_id     = module.net.eks_sg_id
  eks_cluster_role_name     = var.eks_cluster_role_name
  pod_execution_role_name   = var.pod_execution_role_name
  tags                      = local.global_tags
}



