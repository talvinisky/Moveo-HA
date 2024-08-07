resource "aws_instance" "nginx" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.ec2_security_group_id]
  key_name      = var.key_name

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "nginx-instance"
  }
}

output "instance_id" {
  value = aws_instance.nginx.id
}

output "private_ip" {
  value = aws_instance.nginx.private_ip
}
