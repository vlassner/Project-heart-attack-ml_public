/*
DSML3850: Cloud Computing
Instructor: Thyago Mota
Student(s): 
*/

output "rds_instance_public_ip" {
  description = "The public IP address of the RDS instance"
  value       = aws_db_instance.postgres.address
}

output "rds_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.postgres.arn
}