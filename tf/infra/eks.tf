data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
   host                   = data.aws_eks_cluster.cluster.endpoint
   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
   token                  = data.aws_eks_cluster_auth.cluster.token
   #load_config_file       = false
}


module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "19.8.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.24"
  
  subnet_ids = module.vpc.private_subnets
  vpc_id                               = module.vpc.vpc_id
  
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true

  cluster_endpoint_public_access_cidrs = var.eks_access_ip_list

  create_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = var.role_arn
      username = "max"
      groups   = ["system:masters"]
    },
  ]

  /* cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  } */


  self_managed_node_group_defaults = {
    root_volume_type = "gp3"
    root_volume_size = 40
  }


  self_managed_node_groups = {
    the-only-group = {
      instance_type        = "t3.medium"
      public_ip            = false
      desired_size         = 3
      max_size         = 4
      min_size         = 0
      subnet_ids = [module.vpc.private_subnets[0]]
      launch_template_name   = "go-work-launch-template"
      ami_id = "ami-0abc675cb55533b83"
      tags = {
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
        "k8s.io/cluster-autoscaler/enabled" = "true"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }

}
