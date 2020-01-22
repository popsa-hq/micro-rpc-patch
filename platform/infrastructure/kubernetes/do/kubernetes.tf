data "digitalocean_kubernetes_versions" "k8s_versions" {
  version_prefix = "${var.k8s_version}."
}

data "digitalocean_sizes" "valid_sizes" {
  filter {
    key    = "vcpus"
    values = var.node_cpu
  }

  filter {
    key    = "memory"
    values = var.node_memory
  }

  filter {
    key    = "regions"
    values = [var.region]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

resource "random_id" "k8s_name" {
  byte_length = 4
}

resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name    = "micro-${var.region}-${random_id.k8s_name.hex}"
  region  = var.region
  version = data.digitalocean_kubernetes_versions.k8s_versions.latest_version

  node_pool {
    name       = "default-${random_id.k8s_name.hex}"
    node_count = var.node_count

    # This fails on apply if there were no valid sizes found
    size = length(data.digitalocean_sizes.valid_sizes.sizes) > 0 ? element(data.digitalocean_sizes.valid_sizes.sizes, 0).slug : null
  }
}

# Cluster name is output for later use to configure a kubernetes provider
output "cluster_name" {
  value = digitalocean_kubernetes_cluster.k8s_cluster.name
}
