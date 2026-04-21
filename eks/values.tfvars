# EKS Cluster
cluster_name    = "my-eks-cluster"
cluster_version = "1.31"

cluster_endpoint_access_cidrs = [
  "0.0.0.0/0"
]

# Node Group
node_group_name          = "my-node-group"
node_group_ami_type      = "AL2_x86_64"
node_group_instance_type = ["t3.medium"]

node_group_min_size      = 1
node_group_max_size      = 3
node_group_desired_size  = 2

node_group_capacity_type = "ON_DEMAND"
node_group_disk_size     = 20
