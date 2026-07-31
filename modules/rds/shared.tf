resource "aws_db_subnet_group" "this" {
  name       = "django-rds-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "django-rds-subnet-group"
  }
}


resource "aws_security_group" "this" {
  name        = "django-rds-security-group"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "django-rds-security-group"
  }
}

resource "aws_db_parameter_group" "this" {
  count  = var.use_aurora ? 0 : 1
  name   = "django-rds-parameter-group"
  family = var.parameter_group_family

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name         = "max_connections"
    value        = var.max_connections
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_statement"
    value = var.log_statement
  }

  parameter {
    name  = "work_mem"
    value = var.work_mem
  }

  tags = {
    Name = "django-rds-parameter-group"
  }
}


resource "aws_rds_cluster_parameter_group" "cluster" {
  count = var.use_aurora ? 1 : 0

  name   = "django-aurora-cluster-parameter-group"
  family = var.aurora_parameter_group_family

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name         = "max_connections"
    value        = var.max_connections
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_statement"
    value = var.log_statement
  }

  parameter {
    name  = "work_mem"
    value = var.work_mem
  }

  tags = {
    Name = "django-aurora-cluster-parameter-group"
  }
}
