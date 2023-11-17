# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "ami" {
  description = "The the region where the DB is located."
  type        = string
  # We will hardcode the AMI to our packer built image.
  # In the real world we would orchestrate with CI workflows or similar.
  default     = "ami-0a4a145b049f27673"
}

variable "instance_type" {
  description = "The type of machine the webserver will run on."
  type        = string
  default     = "t2.micro"
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled."
  type        = bool
  default     = true
}

variable "vpc_security_group_ids" {
  description = "The list of security IDs which will associate to this EC2."
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data to provide when launching the instance."
  type        = string
  default     = null
}
