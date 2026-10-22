output "Public IP Address" {   
  value = aws_instance.my_ec2_1.public_ip
}

output "Public DNS" {   
  value = aws_instance.my_ec2_1.public_dns
}

output "Ami" {
    value = aws_instance.my_ec2_1.ami
}