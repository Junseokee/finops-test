#####################
# EKS Cluster
#####################
resource "aws_eks_cluster" "primary_cluster" {
  name     = local.name
  role_arn = aws_iam_role.eks_master_role.arn
  version  = "1.28"
  vpc_config {
    subnet_ids             = var.subnet_id[*]
    endpoint_public_access = true
    public_access_cidrs = [
      "0.0.0.0/0"
    ]
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
}


###################
# Managed Node Groups
###################

resource "aws_iam_role" "eks_nodegroup_role" {
  name = "${local.name}-eks-nodegroup-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryPowerUser" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.eks_nodegroup_role.name
}



resource "aws_eks_node_group" "node_groups" {
  cluster_name    = aws_eks_cluster.primary_cluster.name
  node_group_name = aws_eks_cluster.primary_cluster.name
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = var.subnet_id[*]
  update_config {
    max_unavailable = 1
  }
  scaling_config {
    desired_size = 3
    min_size     = 3
    max_size     = 5
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryPowerUser,
  ]

  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20
}