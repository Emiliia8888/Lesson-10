variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}
