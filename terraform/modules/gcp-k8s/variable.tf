variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default = "cluster-1"
}
variable "project_id" {
description = "project id"
type = string
default = "lyrical-bus-452711-c5" 
}
variable "region" {
  description = "Region for the GKE cluster"
  type        = string
}

variable "deletion_protection" {
  description = "Enable or disable deletion protection"
  type        = bool
  default     = false
}

variable "node_count" {
  description = "Initial node count in the cluster"
  type        = number
}

variable "node_machine_type" {
  description = "Machine type for the nodes"
  type        = string
}

variable "node_disk_size" {
  description = "Disk size for the nodes"
  type        = number
  default     = 70
}

# Optional Node Pool variables
variable "create_node_pool" {
  description = "Set to true to create a custom node pool"
  type        = bool
  default     = false
}

variable "node_pool_name" {
  description = "Name of the custom node pool"
  type        = string
  default     = "custom-node-pool"
}

variable "node_pool_count" {
  description = "Number of nodes in the custom node pool"
  type        = number
  default     = 1
}

variable "node_pool_machine_type" {
  description = "Machine type for the node pool"
  type        = string
  default     = "e2-medium"
}

variable "node_pool_disk_size" {
  description = "Disk size for the node pool nodes"
  type        = number
  default     = 70
}
