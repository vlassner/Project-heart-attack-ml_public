/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): 
*/

variable "region" {
  default = "us-west-1"
}

// update with your default VPC ID
variable "vpc_id" {
  default = "vpc-02153249c434071a2"
}

// update with a public subnet id from your default VPC
variable "subnet_id" {
  default = "subnet-06b351bb99568a2fd"
}

// TODO: update with your Docker image URI
variable "docker_image_uri" {
  default = "060795946302.dkr.ecr.us-west-1.amazonaws.com/dsml3850:prj-03"
} 

// TODO: update with your postgres ARN
variable "postgres_arn" {
  default = "arn:aws:rds:us-west-1:060795946302:db:webapp-postgres-db"
}

