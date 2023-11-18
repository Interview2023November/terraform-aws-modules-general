# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the NAT gateway."
  type        = string
}

variable "environment" {
  description = "The environment the NAT will be run in."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet this NAT belongs to."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "The the region where the bastion is located."
  type        = string
  default     = "us-east-2"
}
