<!-- BEGIN_TF_DOCS -->
# terraform-aws-cicd
Terraform module for CI/CD with AWS CodePipeline, GitHub, and CodeBuild.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codepipeline.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_ecr_repository.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_policy.codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.codebuild_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.codepipeline_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_s3_bucket.codepipeline_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.codepipeline_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the application. | `string` | n/a | yes |
| <a name="input_artifacts_type"></a> [artifacts\_type](#input\_artifacts\_type) | The type of artifact store that will be used for the AWS CodeBuild project. Valid values: NO\_ARTIFACTS, CODEPIPELINE, and S3. | `string` | `"CODEPIPELINE"` | no |
| <a name="input_branch"></a> [branch](#input\_branch) | Branch of the repository ie 'main'. | `string` | n/a | yes |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | Instance type of the build instance. | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_build_description"></a> [build\_description](#input\_build\_description) | Description of the CodeBuild project. | `string` | `"Managed by Terraform"` | no |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | Image for build environment. | `string` | `"\taws/codebuild/amazonlinux2-x86_64-standard:4.0"` | no |
| <a name="input_build_image_pull_credentials_type"></a> [build\_image\_pull\_credentials\_type](#input\_build\_image\_pull\_credentials\_type) | Type of credentials AWS CodeBuild uses to pull images in your build, valid values: 'CODEBUILD' and 'SERVICE\_ROLE'. | `string` | `"CODEBUILD"` | no |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. | `number` | `60` | no |
| <a name="input_build_type"></a> [build\_type](#input\_build\_type) | The type of build environment ie 'LINUX\_CONTAINER' or 'WINDOWS\_CONTAINER'. | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_buildspec"></a> [buildspec](#input\_buildspec) | Optional buildspec declaration to use for building the project. | `string` | `""` | no |
| <a name="input_cache_type"></a> [cache\_type](#input\_cache\_type) | The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO\_CACHE, LOCAL, and S3.  Defaults to NO\_CACHE.  If cache\_type is S3, it will create a prefix within the CodePipeline S3 bucket for storing codebuild cache inside. | `string` | `"NO_CACHE"` | no |
| <a name="input_codebuild_iam_policy"></a> [codebuild\_iam\_policy](#input\_codebuild\_iam\_policy) | Custom IAM policy that will attach to the CodeBuild IAM role | `string` | `""` | no |
| <a name="input_codestar_connection_arn"></a> [codestar\_connection\_arn](#input\_codestar\_connection\_arn) | ARN of the CodeStar connection. | `string` | n/a | yes |
| <a name="input_enable_ecr_repository"></a> [enable\_ecr\_repository](#input\_enable\_ecr\_repository) | Boolean to enable the creation of an ECR repository for projects that build docker images. | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of the environment ie 'dev', 'stage', 'sandbox', 'prod'. | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER\_STORE', or 'SECRETS\_MANAGER' | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>      type  = string<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "name": "NO_ADDITIONAL_BUILD_VARS",<br>    "type": "PLAINTEXT",<br>    "value": "TRUE"<br>  }<br>]</pre> | no |
| <a name="input_file_system_locations"></a> [file\_system\_locations](#input\_file\_system\_locations) | A set of file system locations to to mount inside the build. | `any` | `{}` | no |
| <a name="input_local_cache_modes"></a> [local\_cache\_modes](#input\_local\_cache\_modes) | Specifies settings that AWS CodeBuild uses to store and reuse build dependencies. Valid values: LOCAL\_SOURCE\_CACHE, LOCAL\_DOCKER\_LAYER\_CACHE, and LOCAL\_CUSTOM\_CACHE | `list(string)` | `[]` | no |
| <a name="input_privileged_mode"></a> [privileged\_mode](#input\_privileged\_mode) | (Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | `bool` | `false` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the GitHub repository. | `string` | n/a | yes |
| <a name="input_repo_owner"></a> [repo\_owner](#input\_repo\_owner) | GitHub Organization or Username. | `string` | n/a | yes |
| <a name="input_source_location"></a> [source\_location](#input\_source\_location) | The location of the source code from git or s3. | `string` | `""` | no |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | The type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB\_ENTERPRISE, BITBUCKET or S3. | `string` | `"CODEPIPELINE"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply | `map(string)` | `{}` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for the builds to run inside a VPC. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_policy_arn"></a> [codebuild\_policy\_arn](#output\_codebuild\_policy\_arn) | n/a |
| <a name="output_codebuild_policy_id"></a> [codebuild\_policy\_id](#output\_codebuild\_policy\_id) | n/a |
| <a name="output_codebuild_project_arn"></a> [codebuild\_project\_arn](#output\_codebuild\_project\_arn) | n/a |
| <a name="output_codebuild_role_arn"></a> [codebuild\_role\_arn](#output\_codebuild\_role\_arn) | n/a |
| <a name="output_codebuild_role_id"></a> [codebuild\_role\_id](#output\_codebuild\_role\_id) | n/a |
| <a name="output_codepipeline_arn"></a> [codepipeline\_arn](#output\_codepipeline\_arn) | n/a |
| <a name="output_codepipeline_bucket"></a> [codepipeline\_bucket](#output\_codepipeline\_bucket) | n/a |
| <a name="output_codepipeline_id"></a> [codepipeline\_id](#output\_codepipeline\_id) | n/a |
| <a name="output_codepipeline_policy_arn"></a> [codepipeline\_policy\_arn](#output\_codepipeline\_policy\_arn) | n/a |
| <a name="output_codepipeline_policy_id"></a> [codepipeline\_policy\_id](#output\_codepipeline\_policy\_id) | n/a |
| <a name="output_codepipeline_role_arn"></a> [codepipeline\_role\_arn](#output\_codepipeline\_role\_arn) | n/a |
| <a name="output_codepipeline_role_id"></a> [codepipeline\_role\_id](#output\_codepipeline\_role\_id) | n/a |
| <a name="output_ecr_repository_arn"></a> [ecr\_repository\_arn](#output\_ecr\_repository\_arn) | n/a |
| <a name="output_ecr_repository_url"></a> [ecr\_repository\_url](#output\_ecr\_repository\_url) | n/a |
<!-- END_TF_DOCS -->