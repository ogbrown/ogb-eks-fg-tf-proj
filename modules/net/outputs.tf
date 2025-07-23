output "vpc_id" {
  value = data.aws_vpc.eks.id
}

output "eks_subnet_ids" {
  value = [data.aws_subnet.eks-c.id, data.aws_subnet.eks-b.id]
}
output "eks_sg_id" {
  value = aws_security_group.eks.id
}





