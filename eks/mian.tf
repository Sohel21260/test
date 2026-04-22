data "aws_caller_identity" "current" {}

# EKS Cluster Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.1"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # cloudwatch_log_group_retention_in_days = 1
  # cluster_enabled_log_types              = []

  vpc_id                   = aws_vpc.hydroscope-vpc.id
  subnet_ids = [aws_subnet.Public-subnet-1.id, aws_subnet.Public-subnet-2.id]
  #control_plane_subnet_ids = var.control_plane_subnet_ids

  # create_iam_role          = false
   #iam_role_arn             = aws_iam_role.eks_default_role.arn

  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_access_cidrs

  enable_irsa = true

  cluster_addons = {
    coredns = {
      most_recent   = true
      addon_version = "v1.11.4-eksbuild.2"
    }
    kube-proxy = {
      most_recent   = true
      addon_version = "v1.32.0-eksbuild.2"
    }
    vpc-cni = {
      most_recent   = true
      addon_version = "v1.19.2-eksbuild.5"
    }
    aws-ebs-csi-driver = {
      most_recent   = true
      addon_version = "v1.35.0-eksbuild.1"
    }
    eks-pod-identity-agent = {
      most_recent   = true
      addon_version = "v1.3.2-eksbuild.2"
    }
  }


  # EKS Managed Node Group
  eks_managed_node_groups = {
    "${var.node_group_name}" = {
      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desired_size
      ami_type       = var.node_group_ami_type
      instance_types = var.node_group_instance_type
      capacity_type  = var.node_group_capacity_type
      disk_size      = var.node_group_disk_size

      create_iam_role = false
      iam_role_arn    = aws_iam_role.node_group_role.arn

      #tags = var.tags
    }
  }
}
# Helm Provider for EKS
provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

#create service account for ALB controller
# resource "kubernetes_service_account" "alb" {
 #  metadata {
 #   name      = "${var.cluster_name}-alb"
  
 #   annotations = {
  #     "eks.amazonaws.com/role-arn" = module.alb_controller_irsa.iam_role_arn
 #    }
#   }
 # }
#Install ALB Controller using Helm
resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set = [
    {
      name  = "replicaCount"
      value = 1
    },
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    }
  ]

  depends_on = [module.eks, module.alb_controller_irsa]
}



