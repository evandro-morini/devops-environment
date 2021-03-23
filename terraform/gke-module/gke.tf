resource "google_container_cluster" "this" {
  name                     = var.cluster_name
  location                 = var.cluster_location
  initial_node_count       = var.initial_node_count
  remove_default_node_pool = var.remove_default_node_pool
}