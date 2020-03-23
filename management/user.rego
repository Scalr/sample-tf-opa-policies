package terraform

import input.tfplan as tfplan
import input.tfrun as tfrun


allowed_cli_users = ["d.johnson@foo.bar", "j.smith@foo.bar"]


contains(arr, elem) {
  arr[_] = elem
}

deny["User is not allowed to perform runs from Terraform CLI"] {
    "tfe-cli" == tfrun.source
    not contains(allowed_cli_users, tfrun.created_by.name)
}

deny["Only commits from authorized authors are allowed to trigger AWS infrastructure update"] {
    "tfe-vcs" == tfrun.source
    resource := tfplan.resource_changes[_]
    "aws" == resource.provider_name
    not endswith(tfrun.created_by.email, "-aws-ops@foo.bar")
}
