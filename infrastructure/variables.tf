variable "region" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "Name of an existing EC2 key pair to SSH into the instance."
}

variable "my_ip_cidr" {
  type        = string
  description = "Your public IPv4 as CIDR, e.g., 203.0.113.10/32"
}

variable "db_name" {
  type        = string
  default     = "appdb"
  description = "Initial database name."
}

variable "db_username" {
  type        = string
  default     = "appuser"
  description = "Master username for RDS."
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Master password for RDS. Pass via env var TF_VAR_db_password."
}

variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name, e.g., grocerymate-<username>-<random>"
}

