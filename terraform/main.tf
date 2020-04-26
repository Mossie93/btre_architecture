variable "digitalocean_token" {
  type = string
  description = "Your digitalocean API token"
}

provider "digitalocean" {
  token = var.digitalocean_token
}
