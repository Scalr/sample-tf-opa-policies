version = "v1"

policy "enforce_aws_resource" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}

policy "enforce_iam_and_workspace" {
  enabled           = true
  enforcement_level = "hard-mandatory"
}