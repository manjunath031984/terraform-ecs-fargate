resource "aws_security_group" "nlb" {
  name        = "${var.name_prefix}-nlb-sg"
  description = "NLB ingress from internal networks"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-nlb-sg" })
}

resource "aws_security_group_rule" "nlb_ingress" {
  for_each          = toset(var.allowed_internal_cidrs)
  type              = "ingress"
  security_group_id = aws_security_group.nlb.id
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [each.value]
  description       = "HTTPS from internal CIDR ${each.value}"
}

resource "aws_security_group_rule" "nlb_http_ingress" {
  for_each          = toset(var.allowed_internal_cidrs)
  type              = "ingress"
  security_group_id = aws_security_group.nlb.id
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = [each.value]
  description       = "HTTP redirect from internal CIDR ${each.value}"
}

resource "aws_security_group_rule" "nlb_egress" {
  type                     = "egress"
  security_group_id        = aws_security_group.nlb.id
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 443
  source_security_group_id = aws_security_group.alb.id
  description              = "Forward to ALB"
}

resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "ALB receives traffic only from NLB"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-alb-sg" })
}

resource "aws_security_group_rule" "alb_https_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.alb.id
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.nlb.id
  description              = "HTTPS from NLB"
}

resource "aws_security_group_rule" "alb_http_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.alb.id
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.nlb.id
  description              = "HTTP redirect from NLB"
}

resource "aws_security_group_rule" "alb_egress" {
  type                     = "egress"
  security_group_id        = aws_security_group.alb.id
  protocol                 = "tcp"
  from_port                = var.container_port
  to_port                  = var.container_port
  source_security_group_id = aws_security_group.ecs_tasks.id
  description              = "Forward to ECS tasks"
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name_prefix}-ecs-tasks-sg"
  description = "ECS task ingress from ALB"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-ecs-tasks-sg" })
}

resource "aws_security_group_rule" "ecs_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs_tasks.id
  protocol                 = "tcp"
  from_port                = var.container_port
  to_port                  = var.container_port
  source_security_group_id = aws_security_group.alb.id
  description              = "Application traffic from ALB"
}

resource "aws_security_group_rule" "ecs_egress_https" {
  type              = "egress"
  security_group_id = aws_security_group.ecs_tasks.id
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "HTTPS egress for AWS APIs and integrations"
}

resource "aws_security_group_rule" "ecs_egress_postgres" {
  type                     = "egress"
  security_group_id        = aws_security_group.ecs_tasks.id
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.aurora.id
  description              = "PostgreSQL to Aurora"
}

resource "aws_security_group" "aurora" {
  name        = "${var.name_prefix}-aurora-sg"
  description = "Aurora PostgreSQL ingress from ECS tasks"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.name_prefix}-aurora-sg" })
}

resource "aws_security_group_rule" "aurora_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.aurora.id
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.ecs_tasks.id
  description              = "PostgreSQL from ECS tasks"
}

