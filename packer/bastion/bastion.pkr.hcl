packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "aws-bastion"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "aws-bastion"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  # This serves more as an illustration of how we'd package different AMIs for bastions compared to webservers than anything else.
  # In this case fail2ban probably won't help us much because we'll be using key-based auth anyway.
  # In real life we'd consider a number of techniques to reduce surface area, enforce least-privilege, and enhance auditing.
  provisioner "shell" {
    inline = [
      "echo Installing security features",
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y fail2ban",
      "sudo systemctl enable fail2ban.service"
    ]
  }
}
