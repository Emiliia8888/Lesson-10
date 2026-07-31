resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier = var.identifier

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  db_name  = var.database_name
  username = var.master_username
  password = var.master_password

  multi_az = var.multi_az

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  parameter_group_name   = var.use_aurora ? null : aws_db_parameter_group.this[0].name

  publicly_accessible = false

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot


  tags = {
    Name = "django-rds-instance"
  }
}
