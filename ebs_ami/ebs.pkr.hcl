packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.1.1"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ebs_backed_ami"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
  }
  ssh_username = "ubuntu"
}

build {
  name    = "ebs_backed_ami"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}
