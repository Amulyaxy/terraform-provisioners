resource "aws_instance" "web" {
  ami = "ami-03265a0778a880afb"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.roboshop_all.id]

  tags = {

    Name = "provisioner" 
  }

#   provisioner "local-exec" {
#     command = "echo ${self.private_ip} > inventory" #self = aws_instance
#   }

#   provisioner "local-exec" {
#     command = "ansible-playbook -i inventory web.yaml" #self = aws_instance
#   }
 provisioner "local-exec" {
    command = "echo ${self.private_ip} > inventory"
  }


  provisioner "local-exec" {
    command = "echo this will execute at time of creation, you can trigger other system like email and sending alerts "
  } 

   provisioner "local-exec" {
    command = "echo this will execute at time of creation, you can trigger other system like email and sending alerts "
    when = destroy
  } 
  connection {
    type = "ssh"
    user = "centos"
    password = "DevOps321"
    host = self.public_ip
  }
provisioner "remote-exec" {
  inline = [ 
    "echo 'this is run in remote exec' > /tmp/remote.txt",
    "sudo yum install nginx - y",
    "sudo systemctl start nginx"
   ]
}

  }

  resource "aws_security_group" "roboshop_all" {
    name = "provisioner"
    description = "Allow traffic"
  
    ingress {
        description      = "Allow All ports"
        from_port        = 22 # 0 means all ports
        to_port          = 22 
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }

    ingress {
        description      = "Allow All ports"
        from_port        = 80 # 0 means all ports
        to_port          = 80 
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        #ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
      Name = "provisioners"
    }
  }

   