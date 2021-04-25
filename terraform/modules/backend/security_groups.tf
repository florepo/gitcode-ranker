resource "aws_security_group" "ingress_http" {
  name        = "ingress_http"
  description = "HTTP traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.default_tags,
    {
      Name      = "Ingress TCP 80"
    }
  )
}

resource "aws_security_group" "egress_all" {
  name        = "egress_all"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.default_tags,
    {
      Name      = "Egress ALL"
    }
  )
}

resource "aws_security_group" "ingress_api" {
  name        = "ingress_api"
  description = "Allow ingress to API"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.default_tags,
    {
      Name      = "Ingress TCP 3000"
    }
  )
}
