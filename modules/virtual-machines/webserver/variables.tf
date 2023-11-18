# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "ami" {
  description = "The the region where the DB is located."
  type        = string
  # We will hardcode the AMI to our packer built image.
  # In the real world we would orchestrate with CI workflows or similar.
  default = "ami-0a4a145b049f27673"
}

variable "instance_type" {
  description = "The type of machine the webserver will run on."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the keypair we will use for ssh access."
  type        = string
  default     = null
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled."
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the webserver."
  type        = string
  default     = "webserver"
}

variable "subnet_id" {
  description = "The subnet where the webserver will be attached."
  type        = string
  default     = null
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
