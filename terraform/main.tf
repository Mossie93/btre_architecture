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
