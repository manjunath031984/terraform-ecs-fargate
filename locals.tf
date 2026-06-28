locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = var.owner
      CostCenter  = var.cost_center
    },
    var.additional_tags
  )

  application_environment = {
    AWS_REGION            = var.aws_region
    ENVIRONMENT           = var.environment
    ADFS_METADATA_URL     = var.adfs_metadata_url
    ATLAS_EMAIL_PROXY_URL = var.atlas_email_proxy_url
    WRITEAPI_URL          = var.writeapi_url
    DATA_LAKE_URL         = var.data_lake_url
    CXO_URL               = var.cxo_url
    MDS_URL               = var.mds_url
    PI_URL                = var.pi_url
    S3_BUCKET_NAME        = module.s3.bucket_name
    DB_HOST               = module.aurora_postgres.cluster_endpoint
    DB_READER_HOST        = module.aurora_postgres.reader_endpoint
    DB_NAME               = var.aurora_database_name
  }
}
