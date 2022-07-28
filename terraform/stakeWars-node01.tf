terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
    }
  }
}

variable "hcloud_token"{
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "mysshkey" {
  name       = "mysshkey"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_server" "stakeWars-node01" {
  name        = "stakeWars-node01"
  image       = "ubuntu-22.04"
  datacenter  = "fsn1-dc14"
  ssh_keys    = ["mysshkey"]
  server_type = "cpx31"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  depends_on = [hcloud_ssh_key.mysshkey]
}