/* Data */
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

/* Locals */
locals {
  artifacts = local.artifacts_options[var.artifacts_type]
  artifacts_options = {
    "CODEPIPELINE" = {
      type = "CODEPIPELINE"
    },
    "NO_ARTIFACTS" = {
      type = "NO_ARTIFACTS"
    },
    "S3" = {
      type     = "S3"
      location = local.s3_artifacts_enabled ? local.s3_artifacts_bucket_name : "none"
    }
  }
  s3_artifacts_enabled     = var.artifacts_type == "S3"
  s3_artifacts_bucket_name = join("/", [aws_s3_bucket.codepipeline_bucket.id, "${var.env}-${var.app_name}-artifacts"])

  cache = local.cache_options[var.cache_type]
  cache_options = {
    "NO_CACHE" = {
      type = "NO_CACHE"
    },
    "S3" = {
      type     = "S3"
      location = local.s3_cache_enabled ? local.s3_cache_bucket_name : "none"
    },
    "LOCAL" = {
      type  = "LOCAL"
      modes = var.local_cache_modes
    }
  }
  s3_cache_enabled     = var.cache_type == "S3"
  s3_cache_bucket_name = join("/", [aws_s3_bucket.codepipeline_bucket.id, "${var.env}-${var.app_name}-cache"])

  tags_merged = merge(
    {
      "App" = var.app_name
    },
    {
      "Env" = var.env
    },
  var.tags)
}

/* CodePipeline */
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.env}-${var.app_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.id
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
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = format("%s/%s", var.repo_owner, var.repo_name)
        BranchName       = var.branch
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
        ProjectName = "${aws_codebuild_project.codebuild.id}"
      }
    }
  }

  tags = local.tags_merged
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.env}-${var.app_name}-pipeline"
  tags   = local.tags_merged
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.env}-${var.app_name}-pipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codepipeline_policy" {
  name   = "${var.env}-${var.app_name}-pipeline-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${var.codestar_connection_arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "codepipeline_policy_attachment" {
  name       = "${var.env}-${var.app_name}-policy-attachment"
  roles      = [aws_iam_role.codepipeline_role.id]
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

/* CodeBuild */
resource "aws_codebuild_project" "codebuild" {
  name          = "${var.env}-${var.app_name}-build"
  description   = var.build_description
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type     = lookup(local.artifacts, "type", null)
    location = lookup(local.artifacts, "location", null)
  }

  cache {
    type     = lookup(local.cache, "type", null)
    location = lookup(local.cache, "location", null)
    modes    = lookup(local.cache, "modes", null)
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
    image_pull_credentials_type = var.build_image_pull_credentials_type
    type                        = var.build_type
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  source {
    buildspec = var.buildspec
    type      = var.source_type
    location  = var.source_location
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.env}-${var.app_name}-log-group"
      stream_name = "${var.env}-${var.app_name}-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codepipeline_bucket.id}/${var.env}-${var.app_name}-build-logs"
    }
  }

  dynamic "vpc_config" {
    for_each = length(var.vpc_config) > 0 ? [""] : []
    content {
      vpc_id             = lookup(var.vpc_config, "vpc_id", null)
      subnets            = lookup(var.vpc_config, "subnets", null)
      security_group_ids = lookup(var.vpc_config, "security_group_ids", null)
    }
  }

  dynamic "file_system_locations" {
    for_each = length(var.file_system_locations) > 0 ? [""] : []
    content {
      identifier    = lookup(file_system_locations.value, "identifier", null)
      location      = lookup(file_system_locations.value, "location", null)
      mount_options = lookup(file_system_locations.value, "mount_options", null)
      mount_point   = lookup(file_system_locations.value, "mount_point", null)
      type          = lookup(file_system_locations.value, "type", null)
    }
  }

  tags = local.tags_merged
}

resource "aws_iam_role" "codebuild_role" {
  name = "${var.env}-${var.app_name}-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name   = "${var.env}-${var.app_name}-codebuild-policy"
  policy = var.codebuild_iam_policy
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name       = "${var.env}-${var.app_name}-policy-attachment"
  roles      = [aws_iam_role.codebuild_role.id]
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

/* ECR Repository */
resource "aws_ecr_repository" "ecr" {
  count                = var.enable_ecr_repository ? 1 : 0
  name                 = "${var.env}-${var.app_name}-ecr-repository"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags_merged
}
