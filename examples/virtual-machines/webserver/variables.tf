# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "The region where the webserver is located."
  type        = string
  default     = "us-east-2"
}

variable "ami" {
  description = "The AMI the webserver will run."
  type        = string
  # We will hardcode the AMI to our packer built image.
  # In the real world we might orchestrate this with CI workflows or similar.
  default = "ami-0a4a145b049f27673"
}
