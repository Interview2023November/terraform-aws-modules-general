output "public_ip" {
  value       = module.webserver.public_ip
  description = "The public IP of the webserver."
}
