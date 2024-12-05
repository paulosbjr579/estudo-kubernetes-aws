resource "aws_codebuild_project" "codebuild_app_teste_release" {
  name          = "codebuild_${local.app_teste.name}_release"
  description   = "codebuild_${local.app_teste.name}_release"
  service_role  = aws_iam_role.code_build_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    privileged_mode = true

    environment_variable {
      name  = "CONTAINER_NAME"
      value = "hom-900pay-${local.app_teste.name}"
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = local.app_teste.repositoryEcr
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = local.app_teste.region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account
    }

    environment_variable {
      name  = "ENVIRONMENT"
      value = "prod"
    }
  }

  source {
    type            = "GITLAB"
    location        = "https://gitlab.com/${local.app_teste.repository}.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }

    buildspec = local.app_teste.buildspec
  }

  source_version = local.app_teste.branch

  tags = {
    Environment = local.tags.Environment
    Project     = local.tags.Project
  }
}