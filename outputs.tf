output "codepipeline_id" {
  value = aws_codepipeline.codepipeline.id
}

output "codepipeline_arn" {
  value = aws_codepipeline.codepipeline.arn
}

output "codepipeline_bucket" {
  value = aws_s3_bucket.codepipeline_bucket.id
}

output "codepipeline_role_id" {
  value = aws_iam_role.codepipeline_role.id
}

output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "codepipeline_policy_arn" {
  value = aws_iam_policy.codepipeline_policy.arn
}

output "codepipeline_policy_id" {
  value = aws_iam_policy.codepipeline_policy.policy_id
}

output "codebuild_project_arn" {
  value = aws_codebuild_project.codebuild.arn
}

output "codebuild_role_id" {
  value = aws_iam_role.codebuild_role.id
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}

output "codebuild_policy_arn" {
  value = aws_iam_policy.codebuild_policy.arn
}

output "codebuild_policy_id" {
  value = aws_iam_policy.codebuild_policy.policy_id
}

output "ecr_repository_arn" {
  value = aws_ecr_repository.ecr.*.arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.ecr.*.repository_url
}
