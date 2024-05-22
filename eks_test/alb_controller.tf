data "aws_eks_cluster_auth" "share_cluster" {
  name = aws_eks_cluster.primary_cluster.name
}
resource "aws_iam_role" "aws-load-balancer-controller-role" {
  name = "aws-load-balancer-controller-megatree-eks"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(aws_eks_cluster.primary_cluster.identity[0].oidc[0].issuer, "https://", "")}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(aws_eks_cluster.primary_cluster.identity[0].oidc[0].issuer, "https://", "")}:aud" : "sts.amazonaws.com",
            "${replace(aws_eks_cluster.primary_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      },
    ],
  })
}
resource "aws_iam_role_policy_attachment" "aws-load-balancer-controller_attach" {
  role       = aws_iam_role.aws-load-balancer-controller-role.name
  policy_arn = "arn:aws:iam::123456789:policy/AWSLoadBalancerControllerIAMPolicy"
}

# AWSLoadBalancerController add-cluster
resource "helm_release" "aws-load-balancer-controller-app" {

  depends_on = [
    aws_eks_cluster.primary_cluster,
    aws_iam_role.aws-load-balancer-controller-role,
    aws_eks_node_group.node_groups
  ]

  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"
  repository = "./helm"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.primary_cluster.name
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "enableShield"
    value = "false"
  }
  set {
    name  = "enableWaf"
    value = "false"
  }
  set {
    name  = "enableWafv2"
    value = "false"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com\\/role-arn"
    value = aws_iam_role.aws-load-balancer-controller-role.arn
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}