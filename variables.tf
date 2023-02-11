variable "artifacts_type" {
  description = "The type of artifact store that will be used for the AWS CodeBuild project. Valid values: NO_ARTIFACTS, CODEPIPELINE, and S3."
  type        = string
  default     = "CODEPIPELINE"
}

variable "app_name" {
  description = "Name of the application."
  type        = string
}

variable "branch" {
  description = "Branch of the repository ie 'main'."
  type        = string
}

variable "build_compute_type" {
  description = "Instance type of the build instance."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "build_description" {
  description = "Description of the CodeBuild project."
  type        = string
  default     = "Managed by Terraform"
}

variable "build_image" {
  description = "Image for build environment."
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
}

variable "build_image_pull_credentials_type" {
  description = "Type of credentials AWS CodeBuild uses to pull images in your build, valid values: 'CODEBUILD' and 'SERVICE_ROLE'."
  type        = string
  default     = "CODEBUILD"
}

variable "build_timeout" {
  description = "Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed."
  type        = number
  default     = 60
}

variable "build_type" {
  description = "The type of build environment ie 'LINUX_CONTAINER' or 'WINDOWS_CONTAINER'."
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "buildspec" {
  description = "Optional buildspec declaration to use for building the project."
  type        = string
  default     = ""
}

variable "cache_type" {
  description = "The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO_CACHE, LOCAL, and S3.  Defaults to NO_CACHE.  If cache_type is S3, it will create a prefix within the CodePipeline S3 bucket for storing codebuild cache inside."
  type        = string
  default     = "NO_CACHE"
}

variable "codebuild_iam_policy" {
  description = "Custom IAM policy that will attach to the CodeBuild IAM role"
  type        = string
  default     = ""
}

variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection."
  type        = string
}

variable "enable_ecr_repository" {
  description = "Boolean to enable the creation of an ECR repository for projects that build docker images."
  type        = bool
  default     = false
}

variable "env" {
  description = "Name of the environment ie 'dev', 'stage', 'sandbox', 'prod'."
  type        = string
}

variable "environment_variables" {
  description = "A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER_STORE', or 'SECRETS_MANAGER'"
  type = list(object(
    {
      name  = string
      value = string
      type  = string
    }
  ))
  default = [
    {
      name  = "NO_ADDITIONAL_BUILD_VARS"
      value = "TRUE"
      type  = "PLAINTEXT"
    }
  ]
}

variable "file_system_locations" {
  description = "A set of file system locations to to mount inside the build."
  type        = any
  default     = {}
}

variable "local_cache_modes" {
  type        = list(string)
  default     = []
  description = "Specifies settings that AWS CodeBuild uses to store and reuse build dependencies. Valid values: LOCAL_SOURCE_CACHE, LOCAL_DOCKER_LAYER_CACHE, and LOCAL_CUSTOM_CACHE"
}

variable "privileged_mode" {
  description = "(Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images"
  type        = bool
  default     = false
}

variable "repo_owner" {
  description = "GitHub Organization or Username."
  type        = string
}

variable "repo_name" {
  description = "Name of the GitHub repository."
  type        = string
}

variable "source_location" {
  description = "The location of the source code from git or s3."
  type        = string
  default     = ""
}

variable "source_type" {
  description = "The type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET or S3."
  type        = string
  default     = "CODEPIPELINE"
}

variable "tags" {
  description = "Map of tags to apply"
  type        = map(string)
  default     = {}
}

variable "vpc_config" {
  description = "Configuration for the builds to run inside a VPC."
  type        = any
  default     = {}
}
