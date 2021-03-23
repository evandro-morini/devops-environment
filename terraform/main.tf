provider "google" {
  project = "devops-evandro-morini-tests"
  region  = "southamerica-east1"
}
terraform {
  required_version = "~> 0.12.0"
}

module "google_container_cluster" {
  source             = "./gke-module/"
  cluster_name       = "gke-cluster-test"
  cluster_location   = "southamerica-east1"
  initial_node_count = 1
}

module "google_container_node_pool" {
  source             = "./node-pool-module/"
  node_pool_name     = "node-pool-1"
  node_pool_location = "southamerica-east1"
  cluster_name       = module.google_container_cluster.cluster_name
  min_node_count     = 1
  max_node_count     = 2
  machine_type       = "e2-small"
  oauth_scopes       = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
  node_count         = 1
}