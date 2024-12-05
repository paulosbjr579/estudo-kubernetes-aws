
# Criando o Cluster EKS
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = module.vpc_estudo_kubernetes.private_subnet_ids
    security_group_ids = [aws_security_group.eks_node_sg.id] # Adiciona o SG aqui
    endpoint_public_access = true
  }
}

# Criando o Node Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = module.vpc_estudo_kubernetes.private_subnet_ids

  remote_access {
    ec2_ssh_key = "k8s-key" # Opcional: Para acessar via SSH
    source_security_group_ids = [aws_security_group.eks_node_sg.id]
  }

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }
  instance_types = ["t2.medium"]
  ami_type       = "AL2_x86_64"

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}