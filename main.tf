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
  vpc_security_group_ids = ["sg-03a718e7ae6233cef"]
  key_name               = "clave-lucatic"

  tags = {
    Name = var.instance_name
    APP  = "vue2048"
  }


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/clave-lucatic.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "../hello-2048/public_html"
    destination = "/home/ec2-user/"
  }

  provisioner "local-exec" {
    command = "sleep 60 && ansible-playbook -i aws_ec2.yml hello-2048.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y docker",
      "sudo service docker start",
      "sudo systemctl docker start",
      "usermod -a -G docker ec2-user",
      "pip3 install docker-compose",
      "docker pull ghcr.io/frangel13v/hello-2048/hello2048:latest",
      "docker-compose up -d"
    ]
  }
}

