terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws        = { source = "hashicorp/aws", version = "~> 5.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.23" }
    helm       = { source = "hashicorp/helm", version = "~> 2.11" }
  }
}

provider "aws" {
  region = var.region
}


module "vpc" {
  source      = "./modules/vpc"
  environment = var.environment
}

module "ecr" {
  source          = "./modules/ecr"
  environment     = var.environment
  repository_name = "django-app"
}

module "eks" {
  source      = "./modules/eks"
  environment = var.environment
  subnet_ids  = module.vpc.private_subnets
}

module "rds" {
  source      = "./modules/rds"
  environment = var.environment
  name        = "django-db"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets
  db_name     = "django_db"
  username    = "postgres"
  password    = var.db_password
}


data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}


module "jenkins" {
  source                             = "./modules/jenkins"
  environment                        = var.environment
  cluster_name                       = module.eks.cluster_name
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
}

module "argo_cd" {
  source       = "./modules/argo_cd"
  count        = var.create_argo_cd ? 1 : 0
  environment  = var.environment
  cluster_name = module.eks.cluster_name
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "emiliia-terraform-state-lesson-5"
  table_name  = "terraform-lock-table"
}