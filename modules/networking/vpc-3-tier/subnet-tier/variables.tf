# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the subnet."
  type        = string
}

variable "environment" {
  description = "The environment the subnet will be run in."
  type        = string
}

variable "cidrs" {
  description = "The CIDRs list defines the IP ranges which will be assigned to the subnet. Each will go in a different AZ."
  type        = list(string)
}

variable "route_table_id" {
  description = "The route table ID of the route table which will be attached to this subnet."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC this subnet belongs to."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "The region where the bastion is located."
  type        = string
  default     = "us-east-2"
}
