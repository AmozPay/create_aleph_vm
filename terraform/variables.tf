variable "digitalocean_token" {
    type = string
}

variable "ssh_key_id" {
    type = string
}

variable "domain" {
    type = string
}

variable "subdomain" {
    type = string
    default = "vm"
}

variable "project_name" {
    type = string
}

variable "region" {
    type = string
    default = "fra1"
}

variable "size" {
    type = string
    default = "so1_5-4vcpu-32gb"
    description = "Vm model string"
}