# Enforces that workspaces are tagged with the names of the providers.

package terraform

import rego.v1

import input.tfplan as tfplan

deny contains "Can not destroy workspace with active state" if {
	resource := tfplan.resource_changes[_]
	"delete" == resource.change.actions[count(resource.change.actions) - 1]
	"scalr_workspace" == resource.type

	resource.change.before.has_resources
}
