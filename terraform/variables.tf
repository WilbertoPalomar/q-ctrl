variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "domain_name" {
  description = "Domain name for the website"
  type        = string
  default     = "q-ctrl.arbitra.io"
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
  default     = "Z2PC6Q8FPUQZGI"
}
