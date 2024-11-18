provider "aws" {
  profile = "qiross"
  region  = "us-east-1"
}

resource "aws_ecs_cluster" "fastapi_cluster" {
  name = "fastapi-fargate-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_task_definition" "fastapi_task" {
  family                   = "fastapi-fargate-task"
  container_definitions    = jsonencode([
    {
      name      = "fastapi-container"
      image     = "qiross/fastapi-fargate:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_service" "fastapi_service" {
  name            = "fastapi-fargate-service"
  cluster         = aws_ecs_cluster.fastapi_cluster.id
  task_definition = aws_ecs_task_definition.fastapi_task.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  network_configuration {
    subnets         = ["subnet-01fb57be965f0ab32"]
    security_groups = ["sg-06b1d2e2e843529f4"]
    assign_public_ip = true
  }
}
