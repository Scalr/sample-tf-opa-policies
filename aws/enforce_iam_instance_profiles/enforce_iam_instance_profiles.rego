# Validate that the iam_instance_profile is in the allowed list
#

package terraform

import rego.v1

import input.tfplan as tfplan

allowed_iam_profiles := [
	"my_iam_profile",
	"my_iam_profile_2",
	"my_iam_profile_3",
]

array_contains(arr, elem) if {
	arr[_] = elem
}

eval_expression(expr) := name if {
	name := expr[_].name
} else := iamp if {
	iamp = expr
}

deny contains reason if {
	resource := tfplan.resource_changes[_]
	iam := eval_expression(resource.change.after.iam_instance_profile)
	not array_contains(allowed_iam_profiles, iam)

	reason := sprintf(
		"%-40s :: iam_instance_profile '%s' is not allowed.",
		[resource.address, iam],
	)
}
