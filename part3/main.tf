/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): 
*/

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

// create the activity's task execution role
resource "aws_iam_role" "prj_03_task_execution_role" {
  name = "prj_03_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

// attach the task execution policy to the role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.prj_03_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// TODO: create the activity's task role
resource "aws_iam_role" "prj_03_task_role" {
  name = "prj_03_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
       Effect = "Allow",
       Principal = {
         Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
      }
    ]
  })
}

// TODO: create the activity's RDS access policy
resource "aws_iam_policy" "prj_03_rds_access_policy" {
  name        = "prj_03_rds_access_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "rds:CreateDBInstance",
          "rds:DescribeDBInstances",
          "rds:ModifyDBInstance",
          "rds:DeleteDBInstance",
          "rds:CreateDBCluster",
          "rds:DescribeDBClusters",
          "rds:ModifyDBCluster",
          "rds:DeleteDBCluster",
          "rds-db:connect"
        ],
        Resource = var.postgres_arn
      }
    ]
  })
}

// TODO: attach the RDS access policy to the role
resource "aws_iam_role_policy_attachment" "prj_03_task_role_policy_attachment" {
  role       = aws_iam_role.prj_03_task_role.name
  policy_arn = aws_iam_policy.prj_03_rds_access_policy.arn
}

// TODO: get the reference to the security group created in part 2
data "aws_security_group" "prj_03_sg" {
  name = "prj_03_sg"
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

// TODO: create the activity's task definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "prj_03"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.prj_03_task_execution_role.arn
  task_role_arn      = aws_iam_role.prj_03_task_role.arn

  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([{
    name      = "prj_03"
    image     = var.docker_image_uri
    essential = true
    portMappings = [
      {
        containerPort = 5000,
        hostPort      = 5000
      }
    ]
  }])
}

// TODO: create an ECS cluster
resource "aws_ecs_cluster" "cluster" {
  name = "prj-03-cluster"
}

// TODO: create a service to run a single task from the task definition
resource "aws_ecs_service" "service" {
  name            = "prj_03"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [var.subnet_id]
    security_groups  = [data.aws_security_group.prj_03_sg.id]
    assign_public_ip = true
  }
}