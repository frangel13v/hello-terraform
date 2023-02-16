terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0b752bf1df193a6c4"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0a9ed036265226f0e"
  vpc_security_group_ids = [ "sg-03a718e7ae6233cef" ]
  key_name               = "clave-lucatic"

  tags = {
    Name = var.instance_name
    APP  = "vue2048"
  }
  user_data = <<E0H
#!/bin/sh
sudo amazon-linux-extras install -y docker
service docker start
systemctl enable docker
usermod -a -G docker ec2-user
pip3 install docker-compose
mkdir /home/ec2-user/hello-2048
cd /home/ec2-user/hello-2048
wget https://raw.githubusercontent.com/frangel13v/hello-2048/main/docker-compose.yml
docker-compose pull
docker-compose up -d
E0H
}
