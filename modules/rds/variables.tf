variable "vpc_id" {
  description = "VPC ID for RDS security group"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the database"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "use_aurora" {
  description = "Create Aurora cluster instead of standalone RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = "django"
}

variable "master_username" {
  description = "Master database username"
  type        = string
  default     = "django_admin"
}

variable "master_password" {
  description = "Master database password"
  type        = string
  sensitive   = true
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = bool
  default     = false
}

variable "rds_parameter_group_family" {
  description = "Database parameter group family"
  type        = string
  default     = "postgres16"
}

variable "aurora_parameter_group_family" {
  description = "Aurora cluster parameter group family"
  type        = string
  default     = "aurora-postgresql16"
}

variable "max_connections" {
  description = "Maximum number of database connections"
  type        = string
  default     = "100"
}

variable "log_statement" {
  description = "SQL statement logging level"
  type        = string
  default     = "none"
}

variable "work_mem" {
  description = "Memory used for query operations"
  type        = string
  default     = "4096"
}

variable "identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "django-rds-instance"
}

variable "cluster_identifier" {
  description = "Aurora cluster identifier"
  type        = string
  default     = "django-aurora-cluster"
}

variable "writer_identifier" {
  description = "Aurora writer instance identifier"
  type        = string
  default     = "django-aurora-writer"
}

variable "allocated_storage" {
  description = "Allocated storage size in GB"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp3"
}
