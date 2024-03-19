resource "aws_instance" "myec2" {
    ami = "ami-0f403e3180720dd7e"
    instance_type = "t2.micro"
    key_name = "newopenkey"
    vpc_security_group_ids = [aws_security_group.allow.id]

    tags = {
      Name = "NEWVM"
    
    }

    provisioner "file" {
        source = "C:\\Users\\admin\\Desktop\\terra\\redame.txt"
        destination = "/home/ec2-user/readme.txt"       
    }


  provisioner "local-exec" {
    when = create
    command = "echo The server IP address is ${self.private_ip} > myec2ip.yaml"
  }

provisioner "remote-exec" {
    inline = [
      "echo ${self.public_ip}/n${self.private_ip} >> /home/ec2-user/ips.txt",
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo systemctl start nginx"
    ]
}
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("./newopenkey.pem")
      host = self.public_ip
    }
  
}


resource "aws_security_group" "allow" {
  # ... other configuration ...
name = "allow_SSH"
  
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }



  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

