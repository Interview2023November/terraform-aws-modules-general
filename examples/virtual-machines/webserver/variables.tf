# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "The the region where the DB is located."
  type        = string
  default     = "us-east-2"
}

variable "ami" {
  description = "The the region where the DB is located."
  type        = string
  default     = "ami-0d5d9d301c853a04a"
}
