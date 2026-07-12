resource "aws_db_instance" "this" {

  count = var.use_aurora ? 0 : 1


  identifier = var.name


  engine         = var.engine
  engine_version = var.engine_version


  instance_class = var.instance_class


  allocated_storage = 20


  db_name  = var.database_name
  username = var.username
  password = var.password


  db_subnet_group_name = aws_db_subnet_group.this.name


  vpc_security_group_ids = [
    aws_security_group.this.id
  ]


  multi_az = var.multi_az


  parameter_group_name = aws_db_parameter_group.this.name


  skip_final_snapshot = true


  tags = {
    Name = var.name
  }
}