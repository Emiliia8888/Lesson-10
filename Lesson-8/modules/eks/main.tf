resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = "arn:aws:iam::123456789012:role/eks-role"

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

variable "subnet_ids" {}
variable "environment" {}

output "cluster_name" {
  value = aws_eks_cluster.my_cluster.name
}