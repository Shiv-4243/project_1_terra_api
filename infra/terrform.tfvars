vpc_name              = "myvpc-project-1-terra"
vpc_cidr              = "11.0.0.0/16"
public_subnet         = ["11.0.1.0/24", "11.0.2.0/24"]
private_subnet        = ["11.0.3.0/24", "11.0.4.0/24"]
availability_zones    = ["ap-south-1a", "ap-south-1b"]
instance_type_jenkins = "t2.micro"
ingress_rules = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  },
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }
]

egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
]

