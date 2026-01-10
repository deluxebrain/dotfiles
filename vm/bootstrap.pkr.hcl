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
  vm_base_name       = "ghcr.io/cirruslabs/macos-${var.macos_version}-base:latest"
  vm_name            = "${var.macos_version}-bootstrap"
  disk_size_gb       = 80
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

  # Copy host's SSH public key for passwordless access
  provisioner "shell" {
    inline = [
      "mkdir -p ~/.ssh",
      "chmod 700 ~/.ssh",
      "echo '${file(pathexpand("~/.ssh/id_ed25519.pub"))}' >> ~/.ssh/authorized_keys",
      "chmod 600 ~/.ssh/authorized_keys",
      "ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null"
    ]
  }

  # Verify Homebrew and Xcode CLI tools were installed correctly
  provisioner "shell" {
    inline = [
      "echo '=== Verifying installations ==='",
      "eval \"$(/opt/homebrew/bin/brew shellenv)\"",
      "brew --version || (echo 'ERROR: Homebrew not installed' && exit 1)",
      "xcode-select -p || (echo 'ERROR: Xcode CLI tools not installed' && exit 1)",
      "git --version || (echo 'ERROR: git not available' && exit 1)",
      "echo '=== All verifications passed ==='"
    ]
  }
}
