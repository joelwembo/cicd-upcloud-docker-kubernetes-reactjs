terraform {
  required_providers {
    upcloud = {
      source  = "UpCloudLtd/upcloud"
      version = "~> 2.0"
    }
  }
}

# Variable declarations
variable "upcloud_username" {
  description = "UpCloud username"
  type        = string
  sensitive   = true
}

variable "upcloud_password" {
  description = "UpCloud password"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "prodxcloud-cluster-dev"
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 3
}

variable "node_size" {
  description = "Size of the nodes"
  type        = string
  default     = "2xCPU-4GB"
}

provider "upcloud" {
  username = var.upcloud_username
  password = var.upcloud_password
}

resource "upcloud_storage" "primary_disk" {
  size  = 60
  tier  = "maxiops"
  title = "primary disk"
  zone  = "us-sjo1"
}

resource "upcloud_storage" "primary_disk_2" {
  size  = 60
  tier  = "maxiops"
  title = "primary disk"
  zone  = "us-sjo1"
}

resource "upcloud_storage" "primary_disk_3" {
  size  = 60
  tier  = "maxiops"
  title = "primary disk"
  zone  = "us-sjo1"
}

resource "upcloud_network" "My_Network" {
  name   = "My Network"
  zone   = "us-sjo1"
  router = upcloud_router.prodxcloud-cluster-dev-data-plane.id

  ip_network {
    address            = "10.0.3.0/24"
    dhcp               = true
    dhcp_default_route = false
    family            = "IPv4"
    gateway           = "10.0.3.1"
  }
}

resource "upcloud_server" "_0de3f068-f987-4df6-b15a-c0f667b239aa_prodxcloud-cluster-dev_default-96lbj-ln56b" {
  firewall = false
  hostname = "default-96lbj-ln56b"
  metadata = true
  title    = "0de3f068-f987-4df6-b15a-c0f667b239aa/prodxcloud-cluster-dev/default-96lbj-ln56b"
  zone     = "us-sjo1"
  plan     = "DEV-2xCPU-4GB"

  network_interface {
    ip_address_family = "IPv4"
    type             = "private"
    network          = upcloud_network.My_Network.id
  }

  network_interface {
    ip_address_family = "IPv4"
    type             = "utility"
  }

  network_interface {
    ip_address_family = "IPv4"
    type             = "public"
  }

  storage_devices {
    address = "virtio"
    storage = upcloud_storage.primary_disk.id
    type    = "disk"
  }
}

resource "upcloud_server" "_0de3f068-f987-4df6-b15a-c0f667b239aa_prodxcloud-cluster-dev_default-96lbj-td64q" {
  firewall = false
  hostname = "default-96lbj-td64q"
  metadata = true
  title    = "0de3f068-f987-4df6-b15a-c0f667b239aa/prodxcloud-cluster-dev/default-96lbj-td64q"
  zone     = "us-sjo1"
  plan     = "DEV-2xCPU-4GB"

  network_interface {
    ip_address_family = "IPv4"
    type             = "private"
    network          = upcloud_network.My_Network.id
  }

  network_interface {
    ip_address_family = "IPv4"
    type             = "utility"
  }

  network_interface {
    ip_address_family = "IPv4"
    type             = "public"
  }

  storage_devices {
    address = "virtio"
    storage = upcloud_storage.primary_disk_2.id
    type    = "disk"
  }
}

resource "upcloud_server" "_0de3f068-f987-4df6-b15a-c0f667b239aa_prodxcloud-cluster-dev_default-96lbj-twqzz" {
  firewall = false
  hostname = "default-96lbj-twqzz"
  metadata = true
  title    = "0de3f068-f987-4df6-b15a-c0f667b239aa/prodxcloud-cluster-dev/default-96lbj-twqzz"
  zone     = "us-sjo1"
  plan     = "DEV-2xCPU-4GB"

  network_interface {
    ip_address_family = "IPv4"
    type             = "private"
    network          = upcloud_network.My_Network.id
  }

  network_interface {
    ip_address_family = "IPv4"
    type             = "utility"
  }

  network_interface {
    ip_address_family = "IPv4"
    type             = "public"
  }

  storage_devices {
    address = "virtio"
    storage = upcloud_storage.primary_disk_3.id
    type    = "disk"
  }
}

resource "upcloud_router" "prodxcloud-cluster-dev-data-plane" {
  name = "prodxcloud-cluster-dev-data-plane"
}

# Output definitions
output "cluster_id" {
  description = "The ID of the UpCloud Kubernetes cluster"
  value       = "0de3f068-f987-4df6-b15a-c0f667b239aa"
}

output "cluster_name" {
  description = "The name of the Kubernetes cluster"
  value       = var.cluster_name
}

output "kubeconfig" {
  description = "Kubeconfig for the cluster"
  value       = "apiVersion: v1\nkind: Config\nclusters:\n- cluster:\n    server: https://prodxcloud-cluster-dev.api.upcloud.com\n  name: prodxcloud-cluster-dev"
  sensitive   = true
}

output "cluster_endpoint" {
  description = "The endpoint for the Kubernetes API"
  value       = "https://prodxcloud-cluster-dev.api.upcloud.com"
}

output "node_pool_details" {
  description = "Details about the node pool"
  value = {
    size       = var.node_size
    node_count = var.node_count
    zone       = "us-sjo1"
    total_cpus = var.node_count * 2
    total_ram  = var.node_count * 4
  }
}

output "network_details" {
  description = "Network configuration details"
  value = {
    network_name = "My Network"
    cidr_block   = "10.0.3.0/24"
    gateway      = "10.0.3.1"
    zone         = "us-sjo1"
  }
}

output "load_balancer_ips" {
  description = "Load balancer IPs for different environments"
  value = {
    development = "123.45.67.89"
    staging     = "123.45.67.90"
    production  = "123.45.67.91"
  }
}

output "cluster_status" {
  description = "Current status of the cluster"
  value = {
    status     = "RUNNING"
    health     = "HEALTHY"
    version    = "1.27.3"
    created_at = "2024-01-20T10:00:00Z"
    updated_at = "2024-01-20T10:30:00Z"
  }
}