package terraform

import input.tfplan as tfplan
import input.tfrun as tfrun


allowed_cli_users = ["d.johnson", "j.smith"]


contains(arr, elem) {
  arr[_] = elem
}

deny["User is not allowed to perform runs from Terraform CLI"] {
    "tfe-cli" == tfrun.source
    not contains(allowed_cli_users, tfrun.created_by.username)
}

deny["Only commits from authorized authors are allowed to trigger AWS infrastructure update"] {
    "tfe-vcs" == tfrun.source
    resource := tfplan.resource_changes[_]
    "aws" == resource.provider_name
    not endswith(tfrun.vcs.commit.author.email, "-aws-ops@foo.bar")
}
