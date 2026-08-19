package terraform

import rego.v1

import input.tfplan as tfplan
import input.tfrun as tfrun

allowed_cli_users := ["d.johnson", "j.smith"]

array_contains(arr, elem) if {
	arr[_] = elem
}

get_basename(path) := basename if {
	arr := split(path, "/")
	basename := arr[count(arr) - 1]
}

deny contains "User is not allowed to perform runs from Terraform CLI" if {
	"cli" == tfrun.source
	not array_contains(allowed_cli_users, tfrun.created_by.username)
}

deny contains "Only commits from authorized authors are allowed to trigger AWS infrastructure update" if {
	"vcs" == tfrun.source
	resource := tfplan.resource_changes[_]
	provider_name := get_basename(resource.provider_name)
	"aws" == provider_name
	not endswith(tfrun.vcs.commit.author.email, "-aws-ops@foo.bar")
}
