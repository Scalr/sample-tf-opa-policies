# Check variables have descriptions

package terraform

import rego.v1

import input.tfplan as tfplan

get_desc(avar) := desc if {
	desc := avar.description
} else := no_desc if {
	no_desc := ""
}

deny contains reason if {
	var = tfplan.configuration.root_module.variables[key]

	get_desc(var) == ""

	reason := sprintf(
		"%-40s :: Variable must have a description",
		[key],
	)
}
