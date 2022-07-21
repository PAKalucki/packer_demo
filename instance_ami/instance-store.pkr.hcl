packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.1.1"
    }
  }
}

source "amazon-instance" "ubuntu" {
  ami_name       = "instance_ami"
  instance_type  = "c1.medium"
  region         = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "instance-store"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"] ### cannonical
    most_recent = true
  }
  account_id     = "7542-3191-6615"
  s3_bucket      = "pkalucki-tmp"
  x509_cert_path = "certificate.pem"
  x509_key_path  = "private-key.pem"
  ssh_username = "ubuntu"
  bundle_upload_command = "sudo -i -n ec2-upload-bundle -b {{.BucketName}} -m {{.ManifestPath}} -a {{.AccessKey}} -s {{.SecretKey}} -d {{.BundleDirectory}} --location US --batch --retry"
  // bundle_vol_command = "sudo -i -n ec2-bundle-vol -k {{.KeyPath}} -u {{.AccountId}} -c {{.CertPath}} -r {{.Architecture}} -e {{.PrivatePath}}/* -d {{.Destination}} -p {{.Prefix}} --batch --no-filter --no-inherit --partition gpt --partition mbr"

  temporary_iam_instance_profile_policy_document {
    Version = "2012-10-17"
    Statement {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = ["arn:aws:s3:::pkalucki-tmp/*", "arn:aws:s3:::pkalucki-tmp"]
    }
  }
}

build {
  name = "instance_ami"
  sources = [
    "source.amazon-instance.ubuntu"
  ]

  provisioner "shell" {
    inline = ["sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install -y ec2-ami-tools"]
  }

  // provisioner "shell" {
  //   inline = ["sudo apt-get install -y gdisk kpartx parted && export PATH=$PATH:/usr/local/ec2/ec2-ami-tools-1.5.7/bin && ec2-ami-tools-version && sudo ln -s /usr/local/ec2/ec2-ami-tools-1.5.7/bin/ec2-upload-bundle /usr/local/bin/ec2-upload-bundle && sudo ln -s /usr/local/ec2/ec2-ami-tools-1.5.7/bin/ec2-bundle-vol /usr/local/bin/ec2-bundle-vol"]
  // }
}
