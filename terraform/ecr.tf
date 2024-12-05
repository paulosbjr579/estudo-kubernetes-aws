resource "aws_ecr_repository" "ecr_images" {
  name                 = local.app_teste.repositoryEcr
  image_tag_mutability = "MUTABLE"

  tags = {
    Environment = local.tags.Environment
    Project     = local.tags.Project
  }
}