module "vpc" {
  source                 = "/Users/shiv_sush/projects/project_1_terra_api/networking"
  vpc_range              = var.vpc_cidr
  public_subnet_cidr     = var.public_subnet
  private_subnet_cidr    = var.private_subnet
  availability_zones_all = var.availability_zones
}

variable "ingress_rules" {}
variable "egress_rules" {}
module "sg" {
  source          = "/Users/shiv_sush/projects/project_1_terra_api/security groups"
  vpc_id          = module.vpc.vpc_id
  ec2_sg_name     = "sg for ec2"
  jenkins_sg_name = "sg for jenkins with access to port 8080"
  ingress_rules   = var.ingress_rules # Referencing variable defined in tfvars
  egress_rules    = var.egress_rules
}
data "aws_ami" "latest_ubuntu" {
  most_recent = true # Get the most recent AMI

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] # Change based on OS version
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (Ubuntu) official AWS account
}
variable "instance_type_jenkins" {}
module "jenkins" {
  source                = "/Users/shiv_sush/projects/project_1_terra_api/jenkins"
  ami_id                = data.aws_ami.latest_ubuntu.id
  instance_type_jenkins = var.instance_type_jenkins
  public_subnet_jenkins = module.vpc.public_subnet_ids[0]
  jenkins_sg_id         = [module.sg.jenkins_sg.id, module.sg.sg_pub.id]
}