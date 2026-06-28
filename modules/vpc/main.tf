locals {
  azs = {
    for index, az in var.availability_zones : az => {
      index       = index
      public_cidr = var.public_subnet_cidrs[index]
      ecs_cidr    = var.private_ecs_subnet_cidrs[index]
      db_cidr     = var.database_subnet_cidrs[index]
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(var.tags, { Name = "${var.name_prefix}-vpc" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name_prefix}-igw" })
}

resource "aws_subnet" "public" {
  for_each                = local.azs
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.public_cidr
  availability_zone       = each.key
  map_public_ip_on_launch = false
  tags                    = merge(var.tags, { Name = "${var.name_prefix}-public-${each.key}", Tier = "public" })
}

resource "aws_subnet" "private_ecs" {
  for_each          = local.azs
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.ecs_cidr
  availability_zone = each.key
  tags              = merge(var.tags, { Name = "${var.name_prefix}-ecs-${each.key}", Tier = "private-ecs" })
}

resource "aws_subnet" "database" {
  for_each          = local.azs
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.db_cidr
  availability_zone = each.key
  tags              = merge(var.tags, { Name = "${var.name_prefix}-database-${each.key}", Tier = "database" })
}

resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  domain   = "vpc"
  tags     = merge(var.tags, { Name = "${var.name_prefix}-nat-eip-${each.key}" })
}

resource "aws_nat_gateway" "this" {
  for_each      = aws_subnet.public
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id
  tags          = merge(var.tags, { Name = "${var.name_prefix}-nat-${each.key}" })
  depends_on    = [aws_internet_gateway.this]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge(var.tags, { Name = "${var.name_prefix}-public-rt" })
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_ecs" {
  for_each = aws_subnet.private_ecs
  vpc_id   = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }
  tags = merge(var.tags, { Name = "${var.name_prefix}-ecs-rt-${each.key}" })
}

resource "aws_route_table_association" "private_ecs" {
  for_each       = aws_subnet.private_ecs
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_ecs[each.key].id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name_prefix}-database-rt" })
}

resource "aws_route_table_association" "database" {
  for_each       = aws_subnet.database
  subnet_id      = each.value.id
  route_table_id = aws_route_table.database.id
}

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = [for subnet in aws_subnet.public : subnet.id]

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-public-nacl" })
}

resource "aws_network_acl" "private_ecs" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = [for subnet in aws_subnet.private_ecs : subnet.id]

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-ecs-nacl" })
}

resource "aws_network_acl" "database" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = [for subnet in aws_subnet.database : subnet.id]

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-database-nacl" })
}
