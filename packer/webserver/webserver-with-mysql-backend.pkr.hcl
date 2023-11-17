packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "aws-mysql-webserver"
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
  name = "aws-mysql-webserver"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    inline = [
      "echo Installing Mysql",
      "sleep 30",
      "sudo apt-get update",
      "sudo apt install -y default-mysql-server",
    ]
  }
  provisioner "file" {
    source = "i_am_a_webserver.sh"
    destination = "./i_am_a_webserver.sh"
  }
}
