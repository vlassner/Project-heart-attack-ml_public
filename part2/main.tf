/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): 
*/

provider "aws" {
  region = var.region
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

// TODO: create a security group to allow TCP port 5000 ingress traffic from anywhere
resource "aws_security_group" "prj_03_sg" {
  name        = "prj_03_sg"
  description = "Allow TCP 5000 for web app"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow HTTP traffic on port 5000"
    from_port        = 5000
    to_port          = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prj_03_sg"
  }
}

// TODO: create a security group to allow postgres comunicate to outside
resource "aws_security_group" "postgres_sg" {
  name        = "postgres_sg"
  description = "Allow PostgreSQL access from web app"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


// TODO: create the security grou ingress rule to allow access to postgres from "prj_03_sg"
resource "aws_security_group_rule" "postgres_ingress" {
  type                     = "ingress"
  from_port               = 5432
  to_port                 = 5432
  protocol                = "tcp"
  security_group_id       = aws_security_group.postgres_sg.id
  source_security_group_id = aws_security_group.prj_03_sg.id
}

resource "aws_db_subnet_group" "default" {
  name       = "postgres-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Postgres DB subnet group"
  }
}


# # I left this here as a less secure alternative option in case you need to troubleshoot your app running it locally
# resource "aws_security_group" "postgres_sg" {
#   name        = "postgres_sg"
#   description = "Allow PostgreSQL access"
#   vpc_id      = var.vpc_id  

#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow access from anywhere (use with caution)
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# } 

/* --------------------- *
 * Service Configuration *
 * --------------------- */

// TODO: create an RDS instance
resource "aws_db_instance" "postgres" {
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "17.2"
  instance_class          = "db.t3.micro"
  identifier              = "prj03db"
  username                = "postgres"
  password                = "dsml3850"
  skip_final_snapshot     = true
  publicly_accessible     = true
  vpc_security_group_ids  = [aws_security_group.postgres_sg.id]

  lifecycle {
    ignore_changes = [maintenance_window, backup_window]
  }
}