variable "ingress_rules" {}
variable "egress_rules" {}
variable "vpc_id" {}
variable "ec2_sg_name" {}
variable "jenkins_sg_name" {}

resource "aws_security_group" "sg_pub" {
  name        = var.ec2_sg_name
  description = "Security group for public subnet"
  vpc_id      = var.vpc_id
  

  # Dynamic Ingress Rules
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Dynamic Egress Rules
    
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = var.ec2_sg_name
  }
}

resource "aws_security_group" "jenkins_sg" {
    name = var.jenkins_sg_name
    description = "Allow traffic from port 8080"
    vpc_id = var.vpc_id
    ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
  tags = {
    Name = "jenkins_sg"
  }
}

output "jenkins_sg" {
  value = aws_security_group.jenkins_sg
}
output "sg_pub" {
  value = aws_security_group.sg_pub
} 