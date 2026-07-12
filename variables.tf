variable "db_password" {

  description = "Password for RDS database"

  type = string

  sensitive = true

}


variable "region" {

  description = "AWS region"

  type = string

  default = "eu-west-1"

}


variable "environment" {
  type        = string
  default     = "dev"
  description = "Назва середовища"
}


variable "project_name" {
  type        = string
  default     = "django-infra"
  description = "Назва проєкту"
}
