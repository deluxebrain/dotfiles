packer {
  required_plugins {
    tart = {
      version = ">= 1.11.0"
      source  = "github.com/cirruslabs/tart"
    }
  }
}

variable "macos_version" {
  type    = string
  default = "tahoe"
}

source "tart-cli" "bootstrap" {
  vm_base_name       = "ghcr.io/cirruslabs/macos-${var.macos_version}-vanilla:latest"
  vm_name            = "${var.macos_version}-bootstrap"
  disk_size_gb       = 100
  recovery_partition = "relocate"
  ssh_username       = "admin"
  ssh_password       = "admin"
  ssh_timeout        = "120s"

  # Networking: Use bridged networking instead of default NAT.
  # NAT doesn't provide outbound internet access (suspected host firewall).
  # Bridged networking uses the host's network directly.
  run_extra_args = ["--net-bridged=en0"]

  # IP discovery: Use ARP instead of DHCP leases.
  # With bridged networking, the macOS DHCP server isn't involved, so
  # tart ip can't read /var/db/dhcpd_leases. ARP queries the host's ARP table instead.
  ip_extra_args = ["--resolver=arp"]
}

build {
  sources = ["source.tart-cli.bootstrap"]

  provisioner "shell" {
    script = "${path.root}/scripts/setup-ssh.sh"
    environment_vars = [
      "SSH_PUBLIC_KEY=${file(pathexpand("~/.ssh/id_ed25519.pub"))}"
    ]
  }

  provisioner "shell" {
    script = "${path.root}/scripts/install-xcode-clt.sh"
  }

  provisioner "shell" {
    script = "${path.root}/scripts/install-homebrew.sh"
  }

  provisioner "shell" {
    script = "${path.root}/scripts/verify.sh"
  }
}
