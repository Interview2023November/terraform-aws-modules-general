output "address" {
  value       = aws_db_instance.this.address
  description = "The DB address for connections."
}

output "port" {
  value       = aws_db_instance.this.port
  description = "The DB port for connections."
}

output "db_instance_id" {
  value       = aws_db_instance.this.id
  description = "The instance ID of the database server."
}
