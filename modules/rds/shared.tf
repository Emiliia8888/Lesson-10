resource "aws_db_subnet_group" "this" {

  name = "${var.name}-subnet-group"

  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-subnet-group"
  }
}


resource "aws_security_group" "this" {

  name        = "${var.name}-rds-sg"
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id


  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }


  tags = {
    Name = "${var.name}-rds-sg"
  }
}


resource "aws_db_parameter_group" "this" {

  name = "${var.name}-params"

  family = var.engine == "postgres" || var.engine == "aurora-postgresql" ? "postgres15" : "${var.engine}${replace(var.engine_version, ".", "")}"


  parameter {
    name         = "log_statement"
    value        = "all"
    apply_method = "pending-reboot"
  }


  parameter {
    name         = "max_connections"
    value        = "200"
    apply_method = "pending-reboot"
  }


  parameter {
    name         = "work_mem"
    value        = "4096"
    apply_method = "immediate"
  }
}


resource "aws_rds_cluster_parameter_group" "this" {

  count = var.use_aurora ? 1 : 0


  name = "${var.name}-cluster-params"


  family = var.engine == "postgres" || var.engine == "aurora-postgresql" ? "postgres15" : "${var.engine}${replace(var.engine_version, ".", "")}"


  parameter {

    name         = "max_connections"
    value        = "200"
    apply_method = "pending-reboot"
  }


  parameter {

    name         = "log_statement"
    value        = "all"
    apply_method = "pending-reboot"
  }


  parameter {

    name         = "work_mem"
    value        = "4096"
    apply_method = "immediate"
  }

}