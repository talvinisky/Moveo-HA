resource "aws_route53_zone" "example" {
  name = var.domain_name

  tags = {
    Name = "example-zone"
  }
}

output "zone_id" {
  value = aws_route53_zone.example.zone_id
}
resource "aws_route53_record" "alias" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
