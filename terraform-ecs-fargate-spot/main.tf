module "kms" {
  source = "./modules/kms"

  name_prefix = local.name_prefix
  tags        = local.common_tags
}

module "vpc" {
  source = "./modules/vpc"

  name_prefix              = local.name_prefix
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_ecs_subnet_cidrs = var.private_ecs_subnet_cidrs
  database_subnet_cidrs    = var.database_subnet_cidrs
  tags                     = local.common_tags
}

module "logging" {
  source = "./modules/logging"

  name_prefix              = local.name_prefix
  vpc_id                   = module.vpc.vpc_id
  flow_log_subnet_ids      = concat(module.vpc.public_subnet_ids, module.vpc.private_ecs_subnet_ids, module.vpc.database_subnet_ids)
  cloudwatch_kms_key_arn   = module.kms.cloudwatch_key_arn
  log_retention_days       = var.log_retention_days
  alb_access_log_prefix    = "alb"
  nlb_access_log_prefix    = "nlb"
  cloudtrail_s3_key_prefix = "cloudtrail"
  tags                     = local.common_tags
}

module "secrets_manager" {
  source = "./modules/secrets-manager"

  name_prefix             = local.name_prefix
  aurora_master_username  = var.aurora_master_username
  aurora_database_name    = var.aurora_database_name
  secrets_kms_key_id      = module.kms.secrets_key_id
  atlas_email_proxy_url   = var.atlas_email_proxy_url
  adfs_metadata_url       = var.adfs_metadata_url
  smtp_username           = "trs-smtp"
  recovery_window_in_days = var.environment == "prod" ? 30 : 7
  tags                    = local.common_tags
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = var.project_name
  kms_key_arn     = module.kms.s3_key_arn
  tags            = local.common_tags
}

module "s3" {
  source = "./modules/s3"

  name_prefix                    = local.name_prefix
  bucket_name                    = "${local.name_prefix}-app-data-${var.aws_account_id}-${var.aws_region}"
  kms_key_arn                    = module.kms.s3_key_arn
  lifecycle_transition_days      = var.s3_lifecycle_transition_days
  lifecycle_expiration_days      = var.s3_lifecycle_expiration_days
  access_log_bucket_name         = module.logging.access_logs_bucket_name
  access_log_bucket_policy_ready = module.logging.access_logs_bucket_policy_id
  tags                           = local.common_tags
}

module "security_groups" {
  source = "./modules/security-groups"

  name_prefix            = local.name_prefix
  vpc_id                 = module.vpc.vpc_id
  allowed_internal_cidrs = var.allowed_internal_cidrs
  container_port         = var.container_port
  tags                   = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  name_prefix         = local.name_prefix
  ecr_repository_arn  = module.ecr.repository_arn
  log_group_arn       = module.cloudwatch.ecs_log_group_arn
  secrets_arns        = module.secrets_manager.secret_arns
  s3_bucket_arn       = module.s3.bucket_arn
  kms_key_arns        = module.kms.key_arns
  enable_execute_role = true
  tags                = local.common_tags
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  name_prefix = local.name_prefix
  tags        = local.common_tags
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  name_prefix        = local.name_prefix
  log_retention_days = var.log_retention_days
  kms_key_arn        = module.kms.cloudwatch_key_arn
  notification_email = var.notification_email
  tags               = local.common_tags
}

module "acm" {
  source = "./modules/acm"

  domain_name             = var.certificate_domain_name
  private_hosted_zone_id  = module.route53_zone.zone_id
  certificate_description = "Internal TLS certificate for ${var.api_record_name}"
  tags                    = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  name_prefix                = local.name_prefix
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.private_ecs_subnet_ids
  security_group_ids         = [module.security_groups.alb_security_group_id]
  certificate_arn            = module.acm.certificate_arn
  container_port             = var.container_port
  health_check_path          = var.health_check_path
  enable_deletion_protection = var.enable_deletion_protection
  enable_stickiness          = var.enable_alb_stickiness
  access_logs_bucket         = module.logging.access_logs_bucket_name
  access_logs_prefix         = "alb"
  tags                       = local.common_tags
}

module "nlb" {
  source = "./modules/nlb"

  name_prefix                = local.name_prefix
  subnet_ids                 = module.vpc.public_subnet_ids
  security_group_ids         = [module.security_groups.nlb_security_group_id]
  alb_arn                    = module.alb.alb_arn
  alb_listener_arn           = module.alb.https_listener_arn
  alb_dns_name               = module.alb.alb_dns_name
  vpc_id                     = module.vpc.vpc_id
  enable_deletion_protection = var.enable_deletion_protection
  access_logs_bucket         = module.logging.access_logs_bucket_name
  access_logs_prefix         = "nlb"
  tags                       = local.common_tags
}

module "route53_zone" {
  source = "./modules/route53"

  zone_name        = var.private_hosted_zone_name
  record_name      = var.api_record_name
  vpc_id           = module.vpc.vpc_id
  nlb_dns_name     = "placeholder.internal"
  nlb_zone_id      = "Z2FDTNDATAQYW2"
  certificate_name = var.certificate_domain_name
  tags             = local.common_tags
}

module "aurora_postgres" {
  source = "./modules/aurora-postgres"

  name_prefix                  = local.name_prefix
  database_name                = var.aurora_database_name
  master_username              = var.aurora_master_username
  master_password_secret_arn   = module.secrets_manager.database_secret_arn
  engine_version               = var.aurora_engine_version
  instance_class               = var.aurora_instance_class
  subnet_ids                   = module.vpc.database_subnet_ids
  security_group_ids           = [module.security_groups.aurora_security_group_id]
  kms_key_arn                  = module.kms.aurora_key_arn
  backup_retention_days        = var.aurora_backup_retention_days
  deletion_protection          = var.aurora_deletion_protection
  performance_insights_kms_arn = module.kms.aurora_key_arn
  cloudwatch_log_exports       = ["postgresql"]
  tags                         = local.common_tags
}

module "ecs_service" {
  source = "./modules/ecs-service"

  name_prefix                       = local.name_prefix
  cluster_id                        = module.ecs_cluster.cluster_id
  cluster_name                      = module.ecs_cluster.cluster_name
  subnet_ids                        = module.vpc.private_ecs_subnet_ids
  security_group_ids                = [module.security_groups.ecs_tasks_security_group_id]
  task_execution_role_arn           = module.iam.task_execution_role_arn
  task_role_arn                     = module.iam.task_role_arn
  container_name                    = var.container_name
  container_image                   = "${module.ecr.repository_url}:${var.container_image_tag}"
  container_port                    = var.container_port
  cpu                               = var.ecs_task_cpu
  memory                            = var.ecs_task_memory
  desired_count                     = var.ecs_desired_count
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  target_group_arn                  = module.alb.ecs_target_group_arn
  log_group_name                    = module.cloudwatch.ecs_log_group_name
  aws_region                        = var.aws_region
  environment_variables             = local.application_environment
  secrets = {
    DATABASE_SECRET = module.secrets_manager.database_secret_arn
    JWT_SECRET      = module.secrets_manager.jwt_secret_arn
    APP_SECRETS     = module.secrets_manager.application_secret_arn
    SMTP_PASSWORD   = module.secrets_manager.smtp_secret_arn
  }
  tags = local.common_tags
}

module "autoscaling" {
  source = "./modules/autoscaling"

  name_prefix      = local.name_prefix
  cluster_name     = module.ecs_cluster.cluster_name
  service_name     = module.ecs_service.service_name
  min_capacity     = var.ecs_min_capacity
  max_capacity     = var.ecs_max_capacity
  cpu_scale_out    = 70
  cpu_scale_in     = 30
  memory_scale_out = 75
  memory_scale_in  = 30
  alarm_actions    = [module.cloudwatch.alarm_topic_arn]
  tags             = local.common_tags
}

module "monitoring_dashboard" {
  source = "./modules/cloudwatch"

  name_prefix             = "${local.name_prefix}-dashboard"
  log_retention_days      = var.log_retention_days
  kms_key_arn             = module.kms.cloudwatch_key_arn
  notification_email      = var.notification_email
  create_log_group        = false
  ecs_cluster_name        = module.ecs_cluster.cluster_name
  ecs_service_name        = module.ecs_service.service_name
  alb_arn_suffix          = module.alb.alb_arn_suffix
  alb_target_group_suffix = module.alb.ecs_target_group_arn_suffix
  nlb_arn_suffix          = module.nlb.nlb_arn_suffix
  aurora_cluster_id       = module.aurora_postgres.cluster_identifier
  tags                    = local.common_tags
}

module "route53_api" {
  source = "./modules/route53"

  zone_name        = var.private_hosted_zone_name
  record_name      = var.api_record_name
  vpc_id           = module.vpc.vpc_id
  nlb_dns_name     = module.nlb.nlb_dns_name
  nlb_zone_id      = module.nlb.nlb_zone_id
  certificate_name = var.certificate_domain_name
  create_zone      = false
  existing_zone_id = module.route53_zone.zone_id
  tags             = local.common_tags
}


