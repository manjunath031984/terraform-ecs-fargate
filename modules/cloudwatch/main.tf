resource "aws_cloudwatch_log_group" "ecs" {
  count             = var.create_log_group ? 1 : 0
  name              = "/ecs/${var.name_prefix}/trs"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_arn
  tags              = merge(var.tags, { Name = "${var.name_prefix}-ecs-logs" })
}

resource "aws_sns_topic" "alarms" {
  name              = "${var.name_prefix}-alarms"
  kms_master_key_id = var.kms_key_arn
  tags              = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_cloudwatch_log_metric_filter" "errors" {
  count          = var.create_log_group ? 1 : 0
  name           = "${var.name_prefix}-application-errors"
  log_group_name = aws_cloudwatch_log_group.ecs[0].name
  pattern        = "ERROR"

  metric_transformation {
    name      = "ApplicationErrors"
    namespace = "TRS/Application"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "application_errors" {
  count               = var.create_log_group ? 1 : 0
  alarm_name          = "${var.name_prefix}-application-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApplicationErrors"
  namespace           = "TRS/Application"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_actions       = [aws_sns_topic.alarms.arn]
  tags                = var.tags
}

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${var.name_prefix}-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      { type = "metric", x = 0, y = 0, width = 12, height = 6, properties = { title = "ECS CPU/Memory", region = data.aws_region.current.region, metrics = [["AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name], [".", "MemoryUtilization", ".", ".", ".", "."]], view = "timeSeries", stat = "Average" } },
      { type = "metric", x = 12, y = 0, width = 12, height = 6, properties = { title = "ECS Running Tasks", region = data.aws_region.current.region, metrics = [["ECS/ContainerInsights", "RunningTaskCount", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]], view = "timeSeries", stat = "Average" } },
      { type = "metric", x = 0, y = 6, width = 12, height = 6, properties = { title = "ALB Metrics", region = data.aws_region.current.region, metrics = [["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix], [".", "TargetResponseTime", ".", "."], [".", "HTTPCode_Target_5XX_Count", ".", "."]], view = "timeSeries" } },
      { type = "metric", x = 12, y = 6, width = 12, height = 6, properties = { title = "NLB Metrics", region = data.aws_region.current.region, metrics = [["AWS/NetworkELB", "ActiveFlowCount", "LoadBalancer", var.nlb_arn_suffix], [".", "NewFlowCount", ".", "."]], view = "timeSeries" } },
      { type = "metric", x = 0, y = 12, width = 24, height = 6, properties = { title = "Aurora Metrics", region = data.aws_region.current.region, metrics = [["AWS/RDS", "CPUUtilization", "DBClusterIdentifier", var.aurora_cluster_id], [".", "DatabaseConnections", ".", "."], [".", "FreeableMemory", ".", "."]], view = "timeSeries" } }
    ]
  })
}

data "aws_region" "current" {}


