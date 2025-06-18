/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): Victoria Lassner
*/

provider "aws" {
    region = var.region
}

/* ---------------------- *
 * Security Configuration *
 * ---------------------- */

// this role is to allow sagemaker to assume a role
resource "aws_iam_role" "sagemaker_execution_role" {
    name = "SageMakerExecutionRole"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Effect = "Allow",
            Principal = {
                Service = "sagemaker.amazonaws.com"
            },
            Action = "sts:AssumeRole"
        }]
    })
}

// giving full access to resources and operations to the role above
resource "aws_iam_role_policy_attachment" "sagemaker_policy_attachment" {
    role = aws_iam_role.sagemaker_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

// giving full access to resources and operations to the role above
resource "aws_iam_role_policy_attachment" "sagemakercanvas_policy_attachment" {
    role = aws_iam_role.sagemaker_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerCanvasFullAccess"
}

// this policy gives the sagemaker role above access to the specific bucket created here
resource "aws_iam_role_policy" "sagemaker_policy" {
    name = "SageMakerPolicy"
    role = aws_iam_role.sagemaker_execution_role.id
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Effect = "Allow",
            Action = [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket"
            ],
            Resource = [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }]
    })
}

/* ---------------------- *
 * Services Configuration *
 * ---------------------- */

// TODO: create a SageMaker domain with the execution role above
resource "aws_sagemaker_domain" "dsml3850" {
  domain_name = var.domain_name
  auth_mode   = "IAM"
  vpc_id      = var.vpc_id
  subnet_ids  = [var.subnet_id]

  default_user_settings {
    execution_role = aws_iam_role.sagemaker_execution_role.arn
  }
}

// TODO: create a SageMaker user profile
resource "aws_sagemaker_user_profile" "dsml3850_user" {
  domain_id         = aws_sagemaker_domain.dsml3850.id
  user_profile_name = var.user_profile_name
}

// TODO: create an S3 bucket
resource "aws_s3_bucket" "prj_03_bucket" {
  bucket = var.bucket_name
}

// TODO: upload the CSV dataset to the bucket above
resource "aws_s3_object" "heart_attack_file" {
  bucket = aws_s3_bucket.prj_03_bucket.bucket
  key    = "heart_attack.csv"
  source = "../data/heart_attack.csv"
  etag   = filemd5("../data/heart_attack.csv")
}
