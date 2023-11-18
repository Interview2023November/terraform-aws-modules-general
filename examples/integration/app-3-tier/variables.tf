# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_username" {
  description = "The username for the DB."
  type        = string
}

variable "db_password" {
  description = "The password for the DB."
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the initial database."
  type        = string
}

variable "key_name" {
  description = "The name of the keypair which will be used for SSH access to the bastion and webserver."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the system."
  type        = string
  default     = "my-3-tier"
}

variable "instance_class" {
  description = "The type of machine the DB will run on."
  type        = string
  default     = "db.t2.micro"
}

variable "db_port" {
  description = "The port where the DB server will host connections."
  type        = number
  default     = 3306
}

variable "lb_port" {
  description = "The port where the DB server will host connections."
  type        = number
  default     = 443
}

variable "ssh_port" {
  description = "The port where the DB server will host connections."
  type        = number
  default     = 22
}

variable "region" {
  description = "The the region where the bastion is located."
  type        = string
  default     = "us-east-2"
}

variable "webserver_ami" {
  description = "The AMI the webserver will run."
  type        = string
  # We will hardcode the AMI to our packer built image.
  # In the real world we might orchestrate this with CI workflows or similar.
  default = "ami-0a4a145b049f27673"
}

variable "webserver_port" {
  description = "The port where the webserver will host connections."
  type        = number
  default     = 8080
}
