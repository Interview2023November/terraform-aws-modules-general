output "bastion_public_ip" {
  value       = module.bastion.public_ip
  description = "The public IP of the bastion."
}

output "webserver_ip" {
  value       = module.webserver.private_ip
  description = "The private IP of the webserver."
}

output "app_url" {
  value       = module.load_balancer.url
  description = "The URL where the app may be reached."
}
