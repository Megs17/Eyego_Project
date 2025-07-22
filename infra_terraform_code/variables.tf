variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "env" {
  
  type        = string
  default     = "dev"
}
variable "eks_name" {
  type        = string
  default     = "testing-eks"
}

variable "eks_version" {
  type        = string
  default     = "1.32"
}

variable "zone1" {
    description = "Availability Zone 1"
    type        = string
    default     = "us-east-1a"
  
}
variable "zone2" {
    description = "Availability Zone 2"
    type        = string
    default     = "us-east-1b"
}