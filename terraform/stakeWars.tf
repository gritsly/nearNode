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

### Uncomment to see hetzner datacenters data in terraform plan

# data "hcloud_datacenters" "ds" {
# }

# output "hcloud_datacenters" {
#   description = "Datacenters"
#   value       = data.hcloud_datacenters.ds
# }

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
  keep_disk   = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  depends_on = [hcloud_ssh_key.mysshkey]
}

resource "hcloud_server" "stakeWars-node02" {
  name        = "stakeWars-node02"
  image       = "ubuntu-22.04"
  datacenter  = "hel1-dc2"
  ssh_keys    = ["mysshkey"]
  server_type = "cpx31"
  keep_disk   = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  depends_on = [hcloud_ssh_key.mysshkey]
}

resource "hcloud_server" "stakeWars-monit" {
  name        = "stakeWars-monit"
  image       = "ubuntu-22.04"
  datacenter  = "nbg1-dc3"
  ssh_keys    = ["mysshkey"]
  server_type = "cpx11"
  keep_disk   = true
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  depends_on = [hcloud_ssh_key.mysshkey]
}
