output "bastion_public_ip" {
  value       = module.bastion.public_ip
  description = "The public IP of the bastion."
}

output "backend_private_ip" {
  value       = aws_instance.backend.private_ip
  description = "The private IP of the backend."
}
