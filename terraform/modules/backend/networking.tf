resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.default_tags,
    {
      Name = "vpc-${var.app_name}"
    }
  )
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id
  tags   = merge(local.default_tags,
    {
      Name = "route-table-${var.app_name}"
    }
  )
}

resource "aws_main_route_table_association" "default" {
  route_table_id = aws_route_table.default.id
  vpc_id         = aws_vpc.default.id
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = merge(local.default_tags,
    {
      Name = "igw-${var.app_name}"
    }
  )
}

resource "aws_route" "internet_access" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_vpc.default.main_route_table_id
  gateway_id             = aws_internet_gateway.default.id

  depends_on = [aws_internet_gateway.default]
}

locals {
  zone_a_cidr = cidrsubnet(var.cidr_block,1,0)   //10.10.10.0/25
  zone_b_cidr = cidrsubnet(var.cidr_block,1,1)
}

locals {
  public_alb_zone_a_cidr = cidrsubnet(local.zone_a_cidr, 3, 0)  //10.10.10.0/28
  public_alb_zone_b_cidr = cidrsubnet(local.zone_b_cidr, 3, 1)
  ecs_zone_a_cidr        = cidrsubnet(local.zone_a_cidr, 3, 2)
  ecs_zone_b_cidr        = cidrsubnet(local.zone_b_cidr, 3, 4)
}

# ALB subnets
resource "aws_subnet" "public-alb-a" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = local.public_alb_zone_a_cidr
  availability_zone       = "${var.aws_region}a"

  map_public_ip_on_launch = true

  tags = merge(local.default_tags,
    {
      Name = "${var.app_name}-alb-${var.aws_region}a"
    }
  )
}

resource "aws_subnet" "public-alb-b" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = local.public_alb_zone_b_cidr
  availability_zone       = "${var.aws_region}b"

  map_public_ip_on_launch = true
  
  tags = merge(local.default_tags,
    {
      Name = "${var.app_name}-alb-${var.aws_region}b"
    }
  )
}

resource "aws_route_table_association" "public-alb-a" {
  route_table_id    = aws_route_table.default.id
  subnet_id         = aws_subnet.public-alb-a.id
}

resource "aws_route_table_association" "public-alb-b" {
  route_table_id    = aws_route_table.default.id
  subnet_id         = aws_subnet.public-alb-b.id
}

# ECS subnets
resource "aws_subnet" "ecs_subnet_a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = local.ecs_zone_a_cidr
  availability_zone = "${var.aws_region}a"


  tags = merge(local.default_tags,
    {
      Name = "${var.app_name}-ecs-${var.aws_region}a"
    }
  )
}

resource "aws_subnet" "ecs_subnet_b" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = local.ecs_zone_b_cidr
  availability_zone = "${var.aws_region}b"

  tags = merge(local.default_tags,
    {
      Name = "${var.app_name}-ecs-${var.aws_region}b"
    }
  )
}
