resource "aws_instance" "nginx" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]
  key_name      = var.key_name

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "nginx-instance"
  }
}

output "public_ip" {
  value = aws_instance.nginx.public_ip
}

