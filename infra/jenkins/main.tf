variable "ami_id" {}
variable "instance_type_jenkins" {}
variable "jenkins_sg_id" {}
variable "public_subnet_jenkins" {}

resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = var.instance_type_jenkins
  subnet_id                   = var.public_subnet_jenkins
  vpc_security_group_ids      = var.jenkins_sg_id
  associate_public_ip_address = true
  key_name                    = "mumbaikey" # only mention the key-NAME WITH OUT .pem
  user_data                   = file("/Users/shiv_sush/projects/project_1_terra_api/jenkins/jenkins.sh")

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "null_resource" "after_jenkins_setup" {
  depends_on = [aws_instance.jenkins] # Ensure the instance is fully created before executing this

  provisioner "remote-exec" {
    inline = [
      "sleep 120",
      "echo 'Jenkins Admin Password:'",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
      "echo 'teraaform version:'",
      "terraform -version"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu" # Change based on your AMI
      private_key = file("/Users/shiv_sush/projects/project_1_terra_api/jenkins/mumbaikey.pem")
      host        = aws_instance.jenkins.public_ip
    }
  }
}

output "jenkins_instace" {
  value = aws_instance.jenkins
}
