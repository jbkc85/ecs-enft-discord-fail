resource "aws_ecs_cluster" "salesbot" {
  name = "salesbot"
}

resource "aws_ecs_service" "sales_bot_kongs" {
  name            = "sales-bot-kongs"
  task_definition = aws_ecs_task_definition.sales_bot_kongs.arn
  cluster         = aws_ecs_cluster.salesbot.id
  launch_type     = "FARGATE"
  network_configuration {
    assign_public_ip = false
    security_groups = [
      aws_security_group.egress_all.id,
    ]
    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id,
    ]
  }
  desired_count = 1
}

resource "aws_cloudwatch_log_group" "sales_bot" {
  name = "/ecs/sales-bot"
}

resource "aws_ecs_task_definition" "sales_bot_kongs" {
  family = "sales-bot-kongs"
  container_definitions = <<EOF
  [
    {
      "name": "sales-bot",
      "image": "<Image Here>",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "us-west-1",
          "awslogs-group": "/ecs/sales-bot",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  EOF
  execution_role_arn = aws_iam_role.sales_bot_task_execution_role.arn
  task_role_arn      = aws_iam_role.secrets_manager_role.arn
  cpu = 256
  memory = 512
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
}

resource "aws_iam_role" "sales_bot_task_execution_role" {
  name               = "sales-bot-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.sales_bot_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}

resource "aws_iam_role" "secrets_manager_role" {
  name = "secrets-manager-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_manager_policy_attachment" {
  role       = aws_iam_role.secrets_manager_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
