output "ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}
output "jenkins_sg_id" {
  value = module.sg.jenkins_sg.id
}

output "ec2_sg_id" {
  value = module.sg.sg_pub.id
}
output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.jenkins.jenkins_instace.public_ip
}

output "jenkins_site" {
  description = "Jenkins site URL"
  value       = "http://${module.jenkins.jenkins_instace.public_ip}:8080/"
}
