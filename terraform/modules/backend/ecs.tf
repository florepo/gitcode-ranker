resource "aws_ecs_service" "ecs_service" {
  name            = "ecs-service-${var.app_name}"                                     
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"            # Referencing our cluster
  task_definition = "${aws_ecs_task_definition.ecs_task_definition.arn}"   # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 1 # Setting the number of containers we want deployed

  network_configuration {
    subnets          = [aws_subnet.public_ecs_a.id, aws_subnet.public_ecs_b.id]
    assign_public_ip = true # Providing our containers with public IPs
    security_groups   = [
      aws_security_group.ingress_api.id,
      aws_security_group.egress_all.id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_name   = "service"
    container_port   = 3000
  }

  depends_on = [
    aws_lb_listener.http_forward,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy
  ]

  tags = merge(local.default_tags,
    {
      Name = "ecs-service-${var.app_name}" 
    }
  )
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster-${var.app_name}"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = "ecs_task_definition"
  container_definitions = <<DEFINITION
  [
    {
      "name": "service",
      "image": "image",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "awslogs-gitranker",
          "awslogs-region": "eu-west-3",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecs_task_execution_role.arn}"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecr-access" {
  name = "ecs-access"
  role = aws_iam_role.ecs_task_execution_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPushPull",
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "cloudwatch-log-group" {
  name = "log-group-${var.app_name}"
}
