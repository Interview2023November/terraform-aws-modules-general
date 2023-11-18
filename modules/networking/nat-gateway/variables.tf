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
