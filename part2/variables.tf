/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): Victoria Lassner
*/

variable "region" {
  default = "us-west-1"
}

// TODO: update with your default VPC ID
variable "vpc_id" {
  default = "vpc-02153249c434071a2"
}

// TODO: update with a public subnet id from your default VPC
variable "subnet_ids" {
  default = ["subnet-06b351bb99568a2fd", "subnet-0dc0cd03904142911"]
}

