# Enforces that workspaces are tagged with the names of the providers.

package terraform

import rego.v1

import input.tfplan as tfplan
import input.tfrun as tfrun

array_contains(arr, elem) if {
	arr[_] = elem
}

get_basename(path) := basename if {
	arr := split(path, "/")
	basename := arr[count(arr) - 1]
}

deny contains reason if {
	resource := tfplan.resource_changes[_]
	action := resource.change.actions[count(resource.change.actions) - 1]
	array_contains(["create", "update"], action)

	# registry.terraform.io/hashicorp/aws -> aws
	cloud_tag := get_basename(resource.provider_name)

	not tfrun.workspace.tags[cloud_tag]

	reason := sprintf(
		"Workspace must be marked with '%s' tag to create resources in %s cloud",
		[cloud_tag, cloud_tag],
	)
}
