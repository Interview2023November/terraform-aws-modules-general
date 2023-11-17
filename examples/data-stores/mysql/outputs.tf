output "address" {
  value       = module.database_server.address
  description = "The DB address for connections."
}

output "port" {
  value       = module.database_server.port
  description = "The DB port for connections."
}

output "db_instance_id" {
  value       = module.database_server.db_instance_id
  description = "The instance ID of the database server."
}
