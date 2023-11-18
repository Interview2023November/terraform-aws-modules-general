# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the VPC."
  type        = string
}

variable "environment" {
  description = "The environment the VPC will be run in."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "The VPC CIDR defines the IP range which will be assigned to the VPC."
  type        = string
  default     = "10.0.0.0/22"
}

variable "dmz_public_cidr_a" {
  description = "The DMZ CIDR defines the IP range which will be assigned to the DMZ public subnet a."
  type        = string
  default     = "10.0.0.0/25"
}

variable "dmz_public_cidr_b" {
  description = "The DMZ CIDR defines the IP range which will be assigned to the DMZ public subnet b."
  type        = string
  default     = "10.0.0.128/25"
}

variable "front_end_private_cidr" {
  description = "The front end private CIDR defines the IP range which will be assigned to the front end private subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "back_end_private_cidr_a" {
  description = "The back end private CIDR defines the IP range which will be assigned to the back end private subnet in AZ a."
  type        = string
  default     = "10.0.2.0/24"
}

variable "back_end_private_cidr_b" {
  description = "The back end private CIDR defines the IP range which will be assigned to the back end private subnet in AZ b."
  type        = string
  default     = "10.0.3.0/24"
}
