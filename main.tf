module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "emiliia-terraform-state-lesson-5"
  table_name  = "terraform-lock-table"
}

module "vpc" {

  source = "./modules/vpc"

  environment = "dev"

}

module "ecr" {
  source = "./modules/ecr"

  environment = "dev"

  repository_name = "django-app"

}
module "eks" {

  source = "./modules/eks"

  environment = "dev"

  subnet_ids = module.vpc.private_subnets

}
module "rds" {

  source = "./modules/rds"


  name = "app-db"


  use_aurora = true


  engine = "aurora-postgresql"

  engine_version = "15.4"


  instance_class = "db.r6g.large"


  multi_az = true


  database_name = "app"

  username = "admin"

  password = var.db_password


  vpc_id = module.vpc.vpc_id


  subnet_ids = module.vpc.private_subnets


  allowed_security_groups = []

}
