# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the Load Balancer."
  type        = string
}

variable "environment" {
  description = "The environment the load balancer will be run in."
  type        = string
}

variable "subnets" {
  description = "The IDs of the subnets this LB belongs to."
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC to attach this load balancer to."
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the certificate to serve."
  type        = string
  default     = "(REDACTED)"
}

variable "zone_id" {
  description = "The ID of the route53 hosted zone."
  type        = string
  default     = "(REDACTED)"
}

variable "domain" {
  description = "The doimain name to alias to the load balancer."
  type        = string
  default     = "(REDACTED)"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "internal" {
  description = "Whether this LB can only accept private traffic."
  type        = bool
  default     = false
}

variable "redirect_http" {
  description = "Whether this LB will open port 80 to redirect to 443."
  type        = bool
  default     = false
}

variable "target_port" {
  description = "The port where traffic will be directed once received if not overridden."
  type        = number
  default     = 80
}

variable "security_groups" {
  description = "The security groups to associate with the load balancer."
  type        = list(string)
  default     = []
}
