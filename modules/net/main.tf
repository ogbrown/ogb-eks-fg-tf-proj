# Get existing VPC by name tag
data "aws_vpc" "eks" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Data sources to get subnet in us-east-2c
data "aws_subnet" "eks-c" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }
  filter {
    name   = "availability-zone"
    values = ["${var.aws_region}c"]
  }
  filter {
    name   = "tag:Public"
    values = ["false"] # Ensure the subnet is tagged as private
  }
}

# Data sources to get subnet in us-east-2b
data "aws_subnet" "eks-b" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }
  filter {
    name   = "availability-zone"
    values = ["${var.aws_region}b"]
  }
  filter {
    name   = "tag:Public"
    values = ["false"] # Ensure the subnet is tagged as private
  }
}

resource "aws_security_group" "eks" {
  name        = "${var.short_project_name}-sg"
  description = "Security group for EKS cluster"
  vpc_id      = data.aws_vpc.eks.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For demonstration; restrict in production!
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.my_access_ip}/32"] # Replace with your trusted IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}



