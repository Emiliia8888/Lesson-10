# RDS Terraform Module

Universal Terraform module for creating:

- Amazon RDS PostgreSQL instance
- Amazon Aurora PostgreSQL cluster with writer instance

Resource type is controlled by `use_aurora`.

## Features

- Creates DB Subnet Group automatically
- Creates Security Group automatically
- Creates separate Parameter Groups for RDS and Aurora
- Supports configurable PostgreSQL parameters:
  - max_connections
  - log_statement
  - work_mem
- Supports RDS instance
- Supports Aurora PostgreSQL cluster
- Supports Multi-AZ
- Supports configurable engine, version and instance class
- Supports configurable database port and allowed CIDR blocks

## Usage

```hcl
module "rds" {
  source = "./modules/rds"

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

  use_aurora = false

  db_port = 5432

  allowed_cidr_blocks = [
    "10.0.0.0/16"
  ]
}

```

## Outputs

- rds_instance_endpoint
- rds_instance_address
- aurora_cluster_endpoint
- db_endpoint
- db_reader_endpoint
- database_security_group_id
- db_subnet_group_name

## Variables

| Variable | Type | Default | Description |
|---|---|---|---|
| allowed_cidr_blocks | list(string) | ["10.0.0.0/16"] | CIDR blocks allowed to access database |
| db_port | number | 5432 | Database port |
| rds_parameter_group_family | string | postgres16 | RDS parameter group family |
| aurora_parameter_group_family | string | aurora-postgresql16 | Aurora parameter group family |
| use_aurora | bool | false | Create Aurora instead of RDS |
| engine | string | postgres | Database engine |
| engine_version | string | 16 | Database engine version |
| instance_class | string | db.t3.micro | Database instance class |

