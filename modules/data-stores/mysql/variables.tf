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

variable "allocated_Storage_gb" {
  description = "The allocated storage for this RDS instance."
  type        = number
  default     = 10
}

variable "backup_retention_period" {
  description = "The number of days backups will be retained for."
  type        = number
  default     = 0
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Set of log types to enable for exporting to CloudWatch logs. Allowed values are: audit, error, general, slowquery"
  type        = list(string)
  default     = []
  validation {
    condition = alltrue([
      for s in var.enabled_cloudwatch_logs_exports : contains(["audit", "error", "general", "slowquery"], s)
    ])
    error_message = "Valid values for var: enabled_cloudwatch_logs_exports are (audit, error, general, slowquery)."
  }
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  type        = bool
  default     = false
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

variable "publicly_accessible" {
  description = "Whether the database can be accessed publicly."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot for this RDS. Disabling this may be helpful for testing."
  type        = bool
  default     = false
}

variable "db_subnet_group_name" {
  description = "The name of the DB Subnet group."
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate."
  type        = list(string)
  default     = null
}
