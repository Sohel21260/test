variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "EKS Cluster version"
  default     = "1.31"
}

variable "cluster_endpoint_access_cidrs" {
  description = "List of CIDRs allowed to access EKS public endpoint"
  type        = list(string)
  default     = []
}

variable "node_group_name" {
  description = "Name of the node group"
  type        = string
  default     = "my-node-group"
}

variable "node_group_ami_type" {
  description = "Instance ami type for the node group"
  default     = "AL2_x86_64"
}

variable "node_group_instance_type" {
  description = "Instance types for the EKS managed node groups"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_min_size" {
  description = "Minimum size of the node group"
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum size of the node group"
  default     = 3
}

variable "node_group_desired_size" {
  description = "Desired size of the node group"
  default     = 3
}

variable "node_group_capacity_type" {
  description = "The capacity type for the EKS node group (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_group_disk_size" {
  description = "The capacity type for the EKS node group (ON_DEMAND or SPOT)"
  type        = number
  default     = 20
}

