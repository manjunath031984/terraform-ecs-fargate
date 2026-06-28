environment                = "dev"
ecs_desired_count          = 2
ecs_min_capacity           = 2
ecs_max_capacity           = 4
aurora_instance_class      = "db.r6g.large"
aurora_deletion_protection = true
enable_deletion_protection = true
container_image_tag        = "dev"
notification_email         = "platform-alerts@example.com"
additional_tags = {
  Application = "TRS"
  DataClass   = "Confidential"
  Terraform   = "true"
}
