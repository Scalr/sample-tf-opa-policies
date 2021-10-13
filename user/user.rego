package terraform

import input.tfplan as tfplan
import input.tfrun as tfrun


allowed_cli_users = ["d.johnson", "j.smith"]
user_team_names[name] {"vcs" != tfrun.source; name := tfrun.created_by.teams[_].name}


array_contains(arr, elem) {
  arr[_] = elem
}

get_basename(path) = basename{
    arr := split(path, "/")
    basename:= arr[count(arr)-1]
}

deny["User is not allowed to perform runs from Terraform CLI"] {
    "cli" == tfrun.source
    not array_contains(allowed_cli_users, tfrun.created_by.username)
}

deny["Only commits from authorized authors are allowed to trigger AWS infrastructure update"] {
    "vcs" == tfrun.source
    resource := tfplan.resource_changes[_]
    provider_name := get_basename(resource.provider_name)
    "aws" == provider_name
    not endswith(tfrun.vcs.commit.author.email, "-aws-ops@foo.bar")
}

deny["Only admin users allowed to perform this action"] {
    "vcs" != tfrun.source
    not array_contains(user_team_names, "Admins")
}
