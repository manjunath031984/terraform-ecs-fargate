resource "random_password" "database" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "jwt" {
  length  = 48
  special = true
}

resource "random_password" "app" {
  length  = 48
  special = true
}

resource "random_password" "smtp" {
  length  = 32
  special = true
}

resource "aws_secretsmanager_secret" "database" {
  name                    = "${var.name_prefix}/aurora/credentials"
  kms_key_id              = var.secrets_kms_key_id
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = merge(var.tags, { Name = "${var.name_prefix}-database-secret" })
}

resource "aws_secretsmanager_secret_version" "database" {
  secret_id = aws_secretsmanager_secret.database.id
  secret_string = jsonencode({
    username = var.aurora_master_username
    password = random_password.database.result
    database = var.aurora_database_name
    engine   = "postgres"
  })
}

resource "aws_secretsmanager_secret" "jwt" {
  name                    = "${var.name_prefix}/application/jwt"
  kms_key_id              = var.secrets_kms_key_id
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = merge(var.tags, { Name = "${var.name_prefix}-jwt-secret" })
}

resource "aws_secretsmanager_secret_version" "jwt" {
  secret_id     = aws_secretsmanager_secret.jwt.id
  secret_string = jsonencode({ jwt_secret = random_password.jwt.result })
}

resource "aws_secretsmanager_secret" "application" {
  name                    = "${var.name_prefix}/application/config"
  kms_key_id              = var.secrets_kms_key_id
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = merge(var.tags, { Name = "${var.name_prefix}-application-secret" })
}

resource "aws_secretsmanager_secret_version" "application" {
  secret_id = aws_secretsmanager_secret.application.id
  secret_string = jsonencode({
    app_secret            = random_password.app.result
    atlas_email_proxy_url = var.atlas_email_proxy_url
    adfs_metadata_url     = var.adfs_metadata_url
  })
}

resource "aws_secretsmanager_secret" "smtp" {
  name                    = "${var.name_prefix}/smtp/password"
  kms_key_id              = var.secrets_kms_key_id
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = merge(var.tags, { Name = "${var.name_prefix}-smtp-secret" })
}

resource "aws_secretsmanager_secret_version" "smtp" {
  secret_id     = aws_secretsmanager_secret.smtp.id
  secret_string = jsonencode({ username = var.smtp_username, password = random_password.smtp.result })
}
