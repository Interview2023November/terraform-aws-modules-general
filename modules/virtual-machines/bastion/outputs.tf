output "public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "The public IP of the bastion."
}
