variable "sg_name" {
  description = "Security group name"
  type        = string
  default     = "jenkins_sg"
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
  default     = "11.0.0.0/16"
}

variable "public_subnet" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = ["11.0.1.0/24", "11.0.2.0/24"]
}

variable "private_subnet" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = ["11.0.3.0/24", "11.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}
