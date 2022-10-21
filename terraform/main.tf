provider "digitalocean" {
	token = var.digitalocean_token
}

data "digitalocean_project" "project" {
  name = var.project_name
}

data "digitalocean_domain" "domain" {
  name = var.domain
}

resource "digitalocean_droplet" "droplet" {
  name    = "aleph-vm"
  region  = "fra1"
  image   = "ubuntu-20-04-x64"
  size    = var.size
  ssh_keys = [var.ssh_key_id]
}

resource "digitalocean_record" "wildcard_subdomain" {
  type = "A"
  name = "*.${var.subdomain}"
  domain = data.digitalocean_domain.domain.id
  value = digitalocean_droplet.droplet.ipv4_address
}

resource "digitalocean_record" "subdomain" {
  type = "A"
  name = "${var.subdomain}"
  domain = data.digitalocean_domain.domain.id
  value = digitalocean_droplet.droplet.ipv4_address
}

resource "digitalocean_project_resources" "resources" {
  project = data.digitalocean_project.project.id
  resources = [
    digitalocean_droplet.droplet.urn,
  ]
}

output "ipv4" {
  value = digitalocean_droplet.droplet.ipv4_address
}
