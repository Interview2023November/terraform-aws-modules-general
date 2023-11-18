output "subnet_ids" {
  value       = aws_subnet.this[*].id
  description = "The IDs of the subnets."
}
