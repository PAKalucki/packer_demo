packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-instance" "ubuntu" {
  ami_name      = "instance_ami"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  source_ami = "ami-000603c984f38cb61"
  account_id = "7542-3191-6615"
  s3_bucket = "pkalucki-tmp-eu-central"
  x509_cert_path = "certificate.pem"
  x509_key_path = "private-key.pem"
  ssh_username = "ubuntu"
}

build {
  name    = "instance_ami"
  sources = [
    "source.amazon-instance.ubuntu"
  ]
}
