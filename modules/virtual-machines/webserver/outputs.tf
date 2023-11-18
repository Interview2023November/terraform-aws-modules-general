output "public_ip" {
  value       = aws_instance.webserver.public_ip
  description = "The public IP of the webserver."
}

output "private_ip" {
  value       = aws_instance.webserver.private_ip
  description = "The private IP of the webserver."
}

output "id" {
  value       = aws_instance.webserver.id
  description = "The ID of the webserver."
}
