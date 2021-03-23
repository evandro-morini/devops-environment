resource "google_container_node_pool" "this" {
  name       = var.node_pool_name
  location   = var.node_pool_location
  cluster    = var.cluster_name
  node_count = var.node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_config {
    machine_type = var.machine_type
    oauth_scopes = var.oauth_scopes
  }
}