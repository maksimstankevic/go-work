resource "aws_efs_file_system" "efs" {
  creation_token = "go-work-efs"

  tags = {
    Environment = "prod"
  }
}

resource "aws_security_group" "efs" {
  name                   = "go_work_efs_sg"
  description            = "Allow cluster nodes to ese EFS"
  vpc_id                 = module.vpc.vpc_id
  revoke_rules_on_delete = false

  ingress {
    description     = "EFS access from EKS nodes"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    cidr_blocks      = [ var.vpc_cidr_range ]
  }
}

resource "aws_efs_mount_target" "mount_target" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = module.vpc.private_subnets[0]
  security_groups = [ resource.aws_security_group.efs.id ]
}