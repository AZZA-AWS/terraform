module "_shared_vars" {
  source = "../_shared_vars"

}

resource "aws_security_group" "public_sg" {
  name        = "public_sg_${module._shared_vars.env_suffix}"
  description = "public sg for ELB ${module._shared_vars.env_suffix}"
  vpc_id      = module._shared_vars.vpc_id

  ingress {
    description      = "Port 80 traffic on tcp"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "public_sg_${module._shared_vars.env_suffix}"
  }
}


resource "aws_security_group" "private_sg" {
  name        = "private_sg_${module._shared_vars.env_suffix}"
  description = "private sg for ELB ${module._shared_vars.env_suffix}"
  vpc_id      = module._shared_vars.vpc_id

  ingress {
    description     = "TLS from VPC"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.public_sg.id]
  }

  tags = {
    Name = "private_sg_${module._shared_vars.env_suffix}"
  }
}

output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}
