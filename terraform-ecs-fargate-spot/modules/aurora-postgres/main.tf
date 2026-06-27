data "aws_secretsmanager_secret_version" "database" { secret_id = var.master_password_secret_arn }

locals { db_secret = jsondecode(data.aws_secretsmanager_secret_version.database.secret_string) }

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-aurora-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = merge(var.tags, { Name = "${var.name_prefix}-aurora-subnet-group" })
}

resource "aws_rds_cluster" "this" {
  cluster_identifier              = "${var.name_prefix}-aurora-postgres"
  engine                          = "aurora-postgresql"
  engine_version                  = var.engine_version
  database_name                   = var.database_name
  master_username                 = var.master_username
  master_password                 = local.db_secret.password
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = var.security_group_ids
  storage_encrypted               = true
  kms_key_id                      = var.kms_key_arn
  backup_retention_period         = var.backup_retention_days
  preferred_backup_window         = "07:00-09:00"
  preferred_maintenance_window    = "sun:09:00-sun:10:00"
  enabled_cloudwatch_logs_exports = var.cloudwatch_log_exports
  deletion_protection             = var.deletion_protection
  copy_tags_to_snapshot           = true
  skip_final_snapshot             = false
  final_snapshot_identifier       = "${var.name_prefix}-aurora-final"
  tags                            = merge(var.tags, { Name = "${var.name_prefix}-aurora-postgres" })
}

resource "aws_rds_cluster_instance" "this" {
  for_each                        = { writer = 0, reader = 1 }
  identifier                      = "${var.name_prefix}-aurora-${each.key}"
  cluster_identifier              = aws_rds_cluster.this.id
  instance_class                  = var.instance_class
  engine                          = aws_rds_cluster.this.engine
  engine_version                  = aws_rds_cluster.this.engine_version
  publicly_accessible             = false
  performance_insights_enabled    = true
  performance_insights_kms_key_id = var.performance_insights_kms_arn
  auto_minor_version_upgrade      = true
  tags                            = merge(var.tags, { Name = "${var.name_prefix}-aurora-${each.key}" })
}

