packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "base" {
  ami_regions = var.ami_regions
  source_ami_filter {
    filters = {
      name         = "al2023-ami-2023*"
      architecture = "x86_64"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = "amazon-linux-docker_{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.base"]

  provisioner "shell" {
    script = "setup.sh"

    execute_command = "cloud-init status --wait && sudo -E sh '{{ .Path }}'"
  }
}
