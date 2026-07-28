resource "aws_secretsmanager_secret" "django_postgresql" {
  name = "django/postgresql"
}

resource "aws_secretsmanager_secret_version" "django_postgresql" {
  secret_id = aws_secretsmanager_secret.django_postgresql.id

  secret_string = jsonencode({
    username = "django_admin"
    password = var.db_password
    database = "django"
    host     = module.rds.rds_instance_address
    port     = "5432"
  })
}
