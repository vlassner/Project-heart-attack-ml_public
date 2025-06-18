/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): Victoria Lassner
*/

variable "region" {
    default = "us-west-1"
}

// TODO: update with your account ID
variable "account_id" {
    default = "060795946302"
}

// TODO: update with your default VPC ID
variable "vpc_id" {
  default = "vpc-02153249c434071a2"
}

// TODO: update with one of the public subnet ids from your default VPC
variable "subnet_id" {
  default = "subnet-06b351bb99568a2fd"
}

variable "domain_name" {
    default = "DSML3850"
}

variable "user_profile_name" {
    default = "dsml3850-user"
}

variable "bucket_name" {
  default = "prj-03-bucket-vl"
}
