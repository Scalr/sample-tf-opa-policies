# Enforce specific versions for modules

package terraform

import rego.v1

import input.tfplan as tfplan

pins := {
	"terraform-aws-modules/rds/aws": "2.5.0",
	"terraform-aws-modules/another-module": "1.0",
}

version_str(module) := v1 if {
	v1 := module.version_constraint
} else := v2 if {
	v2 := "undefined"
}

deny contains reason if {
	walk(tfplan.configuration.root_module.module_calls, [path, value])
	pinned_version = pins[module_source]
	module_source == value.source
	not pinned_version == value.version_constraint

	reason := sprintf(
		"Module %q (%s) is of an unsupported version %q. Allowed version is %s",
		[path[count(path) - 1], module_source, version_str(value), pinned_version],
	)
}
