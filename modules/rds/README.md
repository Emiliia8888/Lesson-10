# RDS Terraform Module

Universal Terraform module for creating:
- Amazon RDS instance
- Amazon Aurora cluster with writer instance

Resource type is controlled by `use_aurora`.

## Features

- Creates DB Subnet Group automatically
- Creates Security Group automatically
- Creates Parameter Groups
- Supports configurable PostgreSQL parameters:
  - max_connections
  - log_statement
  - work_mem
- Stores database credentials in AWS Secrets Manager
- Supports RDS instance
- Supports Aurora PostgreSQL cluster
- Supports Multi-AZ
- Supports configurable engine, version and instance class

## Usage

```hcl
module "rds" {
  source = "./modules/rds"

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

  engine         = "postgres"
  engine_version = "16"
  instance_class = "db.t3.micro"

  database_name   = "django"
  master_username = "django_admin"
  master_password = var.db_password

  use_aurora = false
}
```

## Configuration Changes

### Change engine

```hcl
engine = "postgres"
```

### Change engine_version

```hcl
engine_version = "16"
```

### Change instance_class

```hcl
instance_class = "db.t3.micro"
```

Example:

```hcl
instance_class = "db.t3.medium"
```

### Enable Multi-AZ

```hcl
multi_az = true
```

## Outputs

- `rds_instance_endpoint`
- `rds_instance_address`
- `aurora_cluster_endpoint`
- `database_security_group_id`
- `db_subnet_group_name`

## Variables

| Variable | Type | Default | Description |
|---|---|---|---|
| vpc_id | string | - | VPC ID for RDS |
| private_subnets | list(string) | - | Private subnet IDs |
| use_aurora | bool | false | Create Aurora instead of RDS |
| engine | string | postgres | Database engine |
| engine_version | string | 16 | Database engine version |
| instance_class | string | db.t3.micro | Database instance class |
| multi_az | bool | false | Enable Multi-AZ |
| database_name | string | django | Initial database name |
| master_username | string | django_admin | Database username |
| backup_retention_period | number | 7 | Backup retention days |
| backup_window | string | 03:00-04:00 | Backup window |
| maintenance_window | string | sun:04:00-sun:05:00 | Maintenance window |
| deletion_protection | bool | true | Enable deletion protection |
| max_connections | string | 100 | PostgreSQL max connections |
| log_statement | string | none | SQL logging |
| work_mem | string | 4096 | PostgreSQL work memory |
