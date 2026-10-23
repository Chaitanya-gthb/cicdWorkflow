output "public_ip_address" {
  value = aws_instance.my_ec2_1.public_ip
}

output "public_dns" {
  value = aws_instance.my_ec2_1.public_dns
}

output "ami" {
  value = aws_instance.my_ec2_1.ami
}