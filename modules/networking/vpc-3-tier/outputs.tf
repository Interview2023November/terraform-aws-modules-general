output "id" {
  value       = aws_vpc.this.id
  description = "The ID of the VPC."
}

output "dmz_public_subnet_ids" {
  value       = module.dmz_public_subnets.subnet_ids
  description = "The IDs of the DMZ public subnets."
}

output "front_end_private_subnet_id" {
  value       = module.front_end_private_subnet.subnet_ids[0]
  description = "The ID of the front end private subnet."
}

output "back_end_private_subnet_ids" {
  value       = module.back_end_private_subnets.subnet_ids
  description = "The IDs of the back end subnets."
}

output "dmz_public_route_table_id" {
  value       = aws_route_table.public.id
  description = "The ID of the DMZ public route table."
}

output "private_route_table_id" {
  value       = aws_route_table.private.id
  description = "The ID of the private route table."
}
