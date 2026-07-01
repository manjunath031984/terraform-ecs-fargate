locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Component   = "s3-bucket-only"
    },
    var.additional_tags
  )
}

