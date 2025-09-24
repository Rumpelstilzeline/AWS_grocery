# ---------------------------
# Existing variables (keep!)
# ---------------------------
variable "region" {
  type    = string
  default = "us-east-1" # keep your region; change if needed
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

# ---------------------------
# New variables (for ALB, ASG, Docker, CloudWatch)
# ---------------------------

variable "vpc_id" {
  type        = string
  description = "Existing VPC id (leave empty if you want to create a VPC separately)"
  default     = ""
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet IDs for the ALB"
  default     = []
}

variable "private_subnets" {
  type        = list(string)
  description = "Private (or app) subnet IDs for ASG EC2 instances"
  default     = []
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "ecr_repo_name" {
  type    = string
  default = "grocery-app"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH to instances. Set to your IP /32."
  default     = "0.0.0.0/0" # change later to var.my_ip_cidr for safety
}

variable "app_port" {
  type    = number
  default = 80
}

