variable "digitalocean_token" {
  type = string
  description = "Your digitalocean API token"
}

variable "ssh_fingerprints" {
  type = list(string)
  description = "List of SSH keys fingerprints"
}

provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_tag" "webserver" {
  name = "web"
}

resource "digitalocean_tag" "env" {
  name = "production"
}

resource "digitalocean_droplet" "webserver" {
  name = "webserver"
  image = "ubuntu-18-04-x64"
  size = "1gb"
  region = "fra1"
  ipv6 = true
  private_networking = false
  tags = [digitalocean_tag.webserver.id, digitalocean_tag.env.id]
  ssh_keys = var.ssh_fingerprints
}

resource "digitalocean_firewall" "webserver" {
  name = "webserver-firewall"
  droplet_ids = [digitalocean_droplet.webserver.id]

  inbound_rule {
    protocol = "tcp"
    port_range = "22"
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "80"
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "443"
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "53"
  }

  outbound_rule {
    protocol = "udp"
    port_range = "53"
  }
}

output "ip_address" {
  value       = digitalocean_droplet.webserver.ipv4_address
  description = "IP address of provisioned droplet"
}