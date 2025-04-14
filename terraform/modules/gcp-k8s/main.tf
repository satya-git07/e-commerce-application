resource "google_container_cluster" "primary" {
  name     = var.cluster_name          # GKE cluster name
  location = var.region                # Region for the cluster
  project  = var.project_id  
  deletion_protection = var.deletion_protection  # Control deletion protection

  initial_node_count = var.node_count            # Number of initial nodes

  node_config {
    machine_type = var.node_machine_type         # VM type for each node
    disk_size_gb = var.node_disk_size            # Disk size per node
  }

  remove_default_node_pool = false              # Default node pool exists
  timeouts {
    create = "90m"
  }
  # Create node pool if variables are provided
  dynamic "node_pool" {
    for_each = var.create_node_pool == true ? [1] : []
    content {
      name = var.node_pool_name
      node_count = var.node_pool_count
      node_config {
        machine_type = var.node_pool_machine_type
        disk_size_gb = var.node_pool_disk_size
      }
    }
  }
}
