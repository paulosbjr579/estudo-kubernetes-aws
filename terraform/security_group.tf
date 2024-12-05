resource "aws_security_group" "k8s_sg" {
  name        = "k8s-sg"
  description = "Security Group for Kubernetes cluster"
  vpc_id      = module.vpc_estudo_kubernetes.vpc_id

  # Permitir SSH (porta 22) para acesso remoto
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acesso SSH de qualquer IP
  }

  # Permitir comunicação interna entre as instâncias do cluster na porta 6443 (Kubernetes API)
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acesso de qualquer IP
  }

  # Permitir HTTP (porta 80) caso tenha algum serviço exposto
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acesso HTTP de qualquer IP
  }

  # Permitir tráfego de resposta para os ingressos (essencial para respostas de tráfego de rede)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Permite todos os tipos de tráfego de saída
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfego de saída para qualquer IP
  }
}


resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node-sg"
  vpc_id      = module.vpc_estudo_kubernetes.vpc_id
  description = "Security group for EKS Node Group"

  # Permitir tráfego entre os nós do cluster (ingress)
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  # Permitir tráfego entre os nós do cluster (ingress)
  ingress {
    from_port   = 0
    to_port     = 443
    protocol    = "tcp"
    self        = true
  }

  # Permitir tráfego entre os nós do cluster (ingress)
  ingress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    self        = true
  }

  # Permitir saída dos nós para qualquer destino (egresso)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-node-sg"
  }
}