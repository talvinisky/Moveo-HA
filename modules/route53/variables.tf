variable "domain_name" {
  description = "The domain name"
  type        = string
}

variable "zone_id" {
  description = "The Route 53 Hosted Zone ID"
  type        = string
}

variable "alb_dns_name" {
  description = "The ALB DNS name"
  type        = string
}

variable "alb_zone_id" {
  description = "The ALB Zone ID"
  type        = string
}
