resource "aws_codepipeline" "codepipeline_teste" {
  name     = "tf-${local.app_teste.name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestarconnections_connection_arn
        FullRepositoryId = local.app_teste.repository
        BranchName       = local.app_teste.branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_app_teste_release.name
      }
    }
  }

#   stage {
#     name = "Deploy"
#
#     action {
#       name            = "Deploy"
#       category        = "Deploy"
#       owner           = "AWS"
#       provider        = "ECS"
#       input_artifacts = ["build_output"]
#       version         = "1"
#
#       configuration = {
#         ClusterName = aws_ecs_cluster.hom-ecs-900pay.name
#         ServiceName = aws_ecs_service.ecs-service-ms-partner-api.name
#         FileName = local.app_teste.fileName
#       }
#     }
#   }

  tags = {
    Environment = local.tags.Environment
    Project     = local.tags.Project
  }
}
