output "arn" {
  value       = aws_lb.this.arn
  description = "The ARN of the load balancer."
}

output "target_group_arn" {
  value       = aws_lb_target_group.this.arn
  description = "The ARN of the load balancer target group."
}

output "url" {
  value       = "https://${var.domain}"
  description = "The URL where the app may be reached."
}
