terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  region  = var.project_id
  zone    = var.region
}


#creating the cluster
module "gke_cluster" {
  source = "./modules/gcp-k8s"

  cluster_name          = var.cluster_name
  region                = "us-west3-c"
  node_count            = 3
  node_machine_type     = "e2-standard-4"
  node_disk_size        = 70
  create_node_pool      = false  # This will create the custom node pool
  node_pool_name        = "custom-node-pool"
  node_pool_count       = 2
  node_pool_machine_type = "e2-standard-4"
}
