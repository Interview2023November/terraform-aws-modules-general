# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the DB server."
  type        = string
}

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

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "The the region where the DB is located."
  type        = string
  default     = "us-east-2"
}

variable "instance_class" {
  description = "The type of machine the DB will run on."
  type        = string
  default     = "db.t2.micro"
}

variable "port" {
  description = "The port where the DB server will host connections."
  type        = number
  default     = 3306
}
