# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "key_name" {
  description = "The name of the keypair we will use for ssh access. Bastions will always use keyed ssh access."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "ami" {
  description = "The the region where the DB is located."
  type        = string
  # We will hardcode the AMI to our packer built image.
  # In the real world we would orchestrate with CI workflows or similar.
  default = "ami-0ca34949803acc44e"
}

variable "associate_public_ip_address" {
  description = "If true, the launched EC2 instance will have a public IP attached."
  type        = bool
  default     = false
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

variable "name" {
  description = "The name of the bastion."
  type        = string
  default     = "bastion"
}

variable "subnet_id" {
  description = "The subnet where the bastion will be attached."
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data to provide when launching the instance."
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "The list of security IDs which will associate to this EC2."
  type        = list(string)
  default     = []
}
