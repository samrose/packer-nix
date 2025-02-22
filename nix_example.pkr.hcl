packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "nix-packer-ubuntu"
  instance_type = "t2.medium"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 40
    volume_type = "gp2"
    delete_on_termination = true
  }
}

build {
  name = "nix-packer-ubuntu"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    inline = ["mkdir /tmp/ansible-playbook"]
  }

  provisioner "file" {
    source = "ansible.yml"
    destination = "/tmp/ansible-playbook/ansible.yml"
  }
 provisioner "shell" {
     script = "provisioner.sh"
  }
}
